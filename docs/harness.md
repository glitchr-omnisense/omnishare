---
title: The Docker harness
order: 5
---

# The Docker harness

```sh
cd docker
docker compose run --rm omnishare test     # PHPUnit (PHP 8.4): the networks, the registry, the JSON, plain PHP
docker compose run --rm omnishare bare     # plain PHP: every link of a page, and every class PHP loaded
docker compose run --rm js                 # assets/omnishare.js on node's test runner (node 22)
docker compose down -v
```

The harness installs this checkout through a path repository into a volume (`/harness`), so the
checkout gets no `vendor/`. `bare` uses Composer's autoloader and nothing else; `Tests/BareTest`
runs it in a PHP process of its own and checks that PHP loaded nothing but omnishare and Composer.
