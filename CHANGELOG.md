# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.0 - 2025-07-11

### Added

- Add the notion of display modes, 3 display modes are available : [Buffer](/README.md#framed_picture-buffer), [Command Line](/README.md#pager-command-line), [Notification](/README.md#bell-notification).

### Changed

- The `secured_files` option is replaced by the `pattern` option which uses a different syntax (see the [README.md](/README.md) file).
- Do not use the `BufReadPre` event anymore, use the `BufReadCmd` event instead. It allows to implement a [Buffer](/README.md#framed_picture-buffer) display mode which prevents any plugin to read the file content.

### Removed

- Dependency to the [nvim-notify](https://github.com/rcarriga/nvim-notify) plugin is now optional, you only need it if you use the [Nofication](/README.md#bell-notification) display mode.
- The `secured_files` option is removed.

## 1.0.1 - 2023-12-12

### Fixed

- Fix bad sensible English word (https://github.com/bgaillard/readonly.nvim/pull/2).

## 1.0.0 - 2023-11-27

### Added

- First stable version of the plugin.
