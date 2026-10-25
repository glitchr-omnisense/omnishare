---
title: Errors
order: 50
---

## Errors

Every exception omnishare throws implements `Omnishare\Exception\OmnishareException`
(a `\Throwable`). There are two, both programming errors to fix rather than conditions to handle:

| Exception | Extends | When | Message |
|---|---|---|---|
| `InvalidShareableException` | `\InvalidArgumentException` | a `Shareable`'s `url`, or its non-empty `image`, is not a whole http(s) address | `The url to share must be a whole http(s) address, "/articles/fuji" given.` |
| `UnknownNetworkException` | `\OutOfBoundsException` | `Registry::get()` or `share()` asked for a name the registry does not hold | `No share network "myspace"; known: facebook, x, pinterest, ...` |

No network calls anything, so nothing fails at run time once the links are built. A relative
address is the usual cause of the first: build the Shareable from the page's absolute URL
(Symfony's `url()`, Laravel's `url()` or `route()`, not `path()`).
