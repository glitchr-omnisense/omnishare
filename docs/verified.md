---
title: Verified, and not
order: 90
---

## Verified, and not

- **Tests.** `docker compose run --rm omnishare test` in `docker/` (PHP 8.4), on 2026-10-26: 25
  tests, 151 assertions, green - every network's address for one page, with and without text,
  picture, hashtags and account; the registry, the JSON; in plain PHP, Composer's autoloader alone,
  nothing loaded but omnishare (`BareTest`). PHPStan at its highest level, no baseline entry.
  `assets/omnishare.js` on node's test runner (`docker compose run --rm js`: 6 tests green on
  2026-10-26) and in a headless Chrome (the share sheet and the copy revealed, the address copied,
  the sheet given the title and address, a Mastodon instance asked and opened).
- **Live, signed out**, on 2026-10-23 in a headless Chrome ([The networks](networks.md#what-each-network-was-seen-to-do)):
  WhatsApp and Telegram show the title and the address on their share page; Facebook, X, Pinterest,
  LinkedIn, Threads and Reddit keep the address (and, for those that take them, the title, picture,
  hashtags and account) through their sign-in page; Mastodon's `/share` exists and asks to sign in
  first; Bluesky's app recognises `/intent/compose` and, signed out, leaves it for its home page.
- **In their source**, on 2026-10-24 ([The networks](networks.md#mastodon-and-bluesky-in-their-source-2026-10-24)):
  Mastodon's `/share` is its composer behind the sign-in, filled with `title`, `text` and `url`
  joined by spaces; Bluesky's `/intent/compose` opens the composer with `text` for a visitor signed
  in, and drops it for one signed out.
- **On an application**: lesringostars builds its articles' Facebook, X, Pinterest and e-mail links
  with omnishare, under Symfony, under its Laravel twin and in its React screen, with the same
  markup as before; this package's tests also pass inside its vendor (PHPUnit 9.6).
- **Not verified**: what each network's composer shows once signed in (no account was used;
  Mastodon's and Bluesky's read in their code, not seen); Mastodon's return to the share page after
  its sign-in (Devise's default, read, not seen); the e-mail in a mail client other than the
  browser's handler; Mastodon instances other than mastodon.social and piaille.fr.

omnishare is affiliated with none of the networks it links to; their names and colours are their
owners'. MIT licence.
