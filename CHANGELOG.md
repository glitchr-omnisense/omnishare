# Changelog

## [Unreleased]

### Fixed

- `Link::newTab()` is true for Mastodon's link without an instance (action `instance`): its address
  is Mastodon's share page, which the script's own markup opens in a new tab (`target="_blank"`); a
  template that follows `newTab` opened it in the same tab when the script was not loaded. `share`
  and `copy` still open no tab.
