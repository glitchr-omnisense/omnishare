---
title: Testing
order: 60
---

## Testing

Links are strings built from a `Shareable`: test them as strings, with no browser and no network.

```php
use Omnishare\Registry;
use Omnishare\Shareable;
use PHPUnit\Framework\TestCase;

final class ArticleShareTest extends TestCase
{
    public function testTheArticleIsSharedWithItsPicture(): void
    {
        $share = Registry::defaults()->share(
            new Shareable('https://example.com/articles/fuji', 'Mount Fuji at dawn', image: 'https://example.com/fuji.jpg'),
            ['pinterest', 'email'],
        );

        self::assertSame(['pinterest', 'email'], array_keys($share->links));
        self::assertStringContainsString('media=https%3A%2F%2Fexample.com%2Ffuji.jpg', $share->url('pinterest'));
        self::assertStringStartsWith('mailto:?subject=Mount%20Fuji%20at%20dawn', $share->url('email'));
        self::assertFalse($share->link('email')->newTab());
    }
}
```

In a functional test of a page, assert the rendered `href`s (Symfony's `WebTestCase` crawler,
Laravel's `assertSee()`): the addresses are deterministic for a given page.

omnishare's own tests, in `Tests/`: `NetworksTest` (every network's address for one page, with and
without text, picture, hashtags and account, the RFC 3986 encoding, Mastodon's instance),
`ShareTest` (the order asked, the JSON, the defaults, a network added or replaced, an unknown network, an address that is not whole, the labels),
`BareTest` (plain PHP with Composer's autoloader alone, nothing loaded but omnishare), and
`Tests/js/omnishare.test.cjs` for the script on node's test runner. Run them with the
[harness](harness.md).
