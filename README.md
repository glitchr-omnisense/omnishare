# omniscient/omnishare

Share links to social networks: a page's address, title, text, picture and hashtags turned into
each network's own share page, an e-mail, a copied link and the device's share sheet. **Plain
links**: no network's script is loaded, so no cookie is set and nothing needs the visitor's
consent; no account, no credential, no API call. Publishing from an account is another family's
job (omnipost).

```php
use Omnishare\{Registry, Shareable};

$share = Registry::defaults()->share(
    new Shareable('https://example.com/articles/fuji', 'Mount Fuji at dawn', image: 'https://example.com/fuji.jpg', hashtags: ['japan']),
    ['facebook', 'x', 'pinterest', 'email', 'native'],   // the ones the page shows, in its order
);
$share->url('x');     // https://twitter.com/intent/tweet?url=https%3A%2F%2Fexample.com%2Farticles%2Ffuji&text=Mount%20Fuji%20at%20dawn&hashtags=japan
$share->toArray();    // the one JSON Twig, Blade and React read: the page, then each link's url, label, icon, colour, newTab, action
```

It requires PHP alone (8.2+): no framework, no template engine, no HTTP client.

## Networks

| Name | Share page | Takes |
|---|---|---|
| `facebook` | `facebook.com/sharer/sharer.php` | the address (Facebook reads the page's og:* tags) |
| `x` | `twitter.com/intent/tweet` | the address, the message, the hashtags, the account to credit |
| `pinterest` | `pinterest.com/pin/create/button/` | the address, the picture, the message |
| `linkedin` | `linkedin.com/sharing/share-offsite/` | the address (LinkedIn reads the og:* tags) |
| `bluesky` | `bsky.app/intent/compose` | one text: the message, the hashtags, the address |
| `mastodon` | `<instance>/share` | one text, on the instance configured, or the visitor's own (asked by the script) |
| `threads` | `threads.com/intent/post` | the message with the hashtags, the address |
| `whatsapp` | `wa.me` | one text: the message, the address |
| `telegram` | `t.me/share/url` | the address, the message |
| `reddit` | `reddit.com/submit` | the address, the title |
| `email` | `mailto:` | the title as subject; the text and the address as body |
| `copy` | the address itself | copied by the script (hidden where the browser has no clipboard) |
| `native` | the address itself | the device's share sheet (`navigator.share`), hidden where there is none |

The message is the Shareable's text, its title when it has none. Every value is encoded as RFC 3986
says (a space is `%20`, never `+`, which a mail client would show as it is).

Why the networks are in this package rather than one package each (`omnishare/<network>`, as the
other omni families do for their providers): a network here is a URL template - no dependency, no
credential, no API, nothing to install or configure apart - so a package per network would be
thirteen repositories of thirty lines each. An application adds its own network by implementing
`NetworkInterface` and `Registry::add()`.

## Documentation

The manual, in [docs/](docs/index.md):

- [Installation and use, in plain PHP](docs/installation.md)
- [Concepts](docs/concepts.md): Shareable, Registry, Share, Link, NetworkInterface, the labels
- [The networks, and how each address was checked](docs/networks.md)
- [Templates: Twig, Blade, React - one JSON](docs/templates.md)
- [The script: share sheet, copy, Mastodon instance](docs/javascript.md)
- [Errors](docs/errors.md) and [testing](docs/testing.md)
- [The Docker harness](docs/harness.md)
- [Verified, and not](docs/verified.md)

## Verified, and not

- Verified (`docker compose run --rm omnishare test` in `docker/`, PHP 8.4): every network's address
  for one page, with and without text, picture, hashtags and account; the registry, the JSON; in
  plain PHP, Composer's autoloader alone, nothing loaded but omnishare (`BareTest`). PHPStan at its
  highest level, no baseline entry. `assets/omnishare.js` on node's test runner (`docker compose run
  --rm js`) and in a headless Chrome (the share sheet and the copy revealed, the address copied, the
  sheet given the title and address, a Mastodon instance asked and opened).
- Verified live on 2026-10-23, signed out, in a headless Chrome (see [docs/networks.md](docs/networks.md)):
  WhatsApp and Telegram show the title and the address on their share page; Facebook, X, Pinterest,
  LinkedIn, Threads and Reddit keep the address (and, for those that take them, the title, picture,
  hashtags and account) through their sign-in page; Mastodon's `/share` exists and asks to sign in
  first; Bluesky's app recognises `/intent/compose` and, signed out, leaves it for its home page.
- Verified in their source on 2026-10-24 (no account needed; [docs/networks.md](docs/networks.md)):
  Mastodon's `/share` is its composer behind the sign-in, filled with `title`, `text` and `url`
  joined by spaces; Bluesky's `/intent/compose` opens the composer with `text` for a visitor signed
  in, and drops it for one signed out (nothing kept for after the sign-in).
- Verified on an application: glitchr's lesringostars builds its articles' Facebook, X, Pinterest
  and e-mail links with omnishare, under Symfony, under its Laravel twin and in its React screen,
  with the same markup as before; this package's tests also pass inside its vendor (PHPUnit 9.6).
- Not verified: what each network's composer shows once signed in (no account was used; Mastodon's
  and Bluesky's read in their code, not seen); Mastodon's return to the share page after its
  sign-in (Devise's default, read, not seen); the
  e-mail in a mail client other than the browser's handler; Mastodon instances other than
  mastodon.social and piaille.fr.

## Licence

MIT. Omnishare is affiliated with none of the networks it links to; their names and colours are
their owners'.
