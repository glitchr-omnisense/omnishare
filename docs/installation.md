---
title: Installation and use, in plain PHP
order: 1
---

# Installation and use, in plain PHP

```sh
composer require omniscient/omnishare
```

```php
<?php
require 'vendor/autoload.php';

use Omnishare\Labels;
use Omnishare\Registry;
use Omnishare\Shareable;

$registry = Registry::defaults(mastodonInstance: null);   // null: the visitor gives their instance

$page = new Shareable(
    url: 'https://example.com/articles/fuji',         // whole: scheme and host
    title: 'Mount Fuji at dawn',
    text: null,                                      // posted instead of the title when given
    image: 'https://example.com/images/fuji.jpg',    // whole as well (Pinterest)
    hashtags: ['japan', 'travel'],
    via: 'example',                                  // X's "via @example"
);

$share = $registry->share($page, ['facebook', 'x', 'pinterest', 'email', 'copy', 'native']);

foreach ($share->links as $link) {
    printf(
        '<a href="%s"%s data-omnishare="%s">%s</a>'."\n",
        htmlspecialchars($link->url),
        $link->newTab() ? ' target="_blank" rel="noopener"' : '',
        htmlspecialchars((string) $link->action),
        htmlspecialchars(Labels::get($link->labelKey, 'en')),
    );
}
```

- `Shareable` checks that its address and its picture are whole http(s) addresses
  (`InvalidShareableException` otherwise): a share page opens on another site, where a path means
  nothing.
- `Registry::share()` takes the networks' names in the order the page shows them; `null` gives
  every network. An unknown name throws `UnknownNetworkException`.
- `Share::url('x')`, `Share::link('x')`, `Share::toArray()` (also `json_encode($share)`).
- `Labels::get($key, $locale)`: omnishare's own labels in English and French
  (`translations/<locale>.php`, plain PHP arrays), for an application without its own words. An
  application with a translator imports those files into it, or keeps its own keys.

## A network of one's own

```php
use Omnishare\Network\AbstractNetwork;
use Omnishare\Shareable;

final class Hatena extends AbstractNetwork
{
    public function name(): string { return 'hatena'; }
    public function uses(): array { return ['url', 'title']; }
    public function shareUrl(Shareable $shareable): string
    {
        return 'https://b.hatena.ne.jp/entry/panel/?'.self::query(['url' => $shareable->url, 'title' => $shareable->title]);
    }
}

$registry->add(new Hatena());   // a network of the same name is replaced
```
