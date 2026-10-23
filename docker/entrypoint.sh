#!/bin/sh
# Installs omnishare from its checkout (/omnishare) into /harness when the
# harness's composer.json changed, then runs the command: "test" for PHPUnit,
# "bare" for the plain-PHP script, "composer ...", "php ..." or "sh" as they are.
set -e
php /omnishare/docker/harness/setup.php
cd /harness
if [ ! -f vendor/autoload.php ]; then
    composer install --no-interaction --no-progress
elif [ composer.json -nt composer.lock ]; then
    composer update --no-interaction --no-progress
fi
case "${1:-test}" in
    test) shift || true; exec vendor/bin/phpunit "$@" ;;
    bare) shift; exec php /omnishare/docker/harness/bin/bare "$@" ;;
    composer|sh|php) exec "$@" ;;
    *) echo "test, bare, composer, sh or php" >&2; exit 2 ;;
esac
