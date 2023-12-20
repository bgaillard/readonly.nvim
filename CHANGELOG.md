# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.0 - 2023-12-20

### Added

- Improve security by not reading files.
- Explain how the plugin works in the [README.md](/README.md) file.
- Now when a secured files is opened its buffer contains a detailed message which explains which exact command can be used to open the file securely.

### Changed

- The `secured_files` option is replaced by the `patterns` option which uses a different syntax (see the [README.md](/README.md) file).

### Removed

- Now the plugin do not display the secured file in Neovim buffers to improve security.
- The `secured_files` option is removed.

## 1.0.1 - 2023-12-12

### Fixed

- Fix bad sensible English word (https://github.com/bgaillard/readonly.nvim/pull/2).

## 1.0.0 - 2023-11-27

### Added

- First stable version of the plugin.
