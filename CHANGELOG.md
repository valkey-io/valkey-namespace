# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-26

### Added
- Initial release of valkey-namespace
- Support for namespacing Valkey commands
- Compatible with valkey-glide-ruby gem
- Support for all standard Valkey commands
- Transaction support (MULTI/EXEC)
- Pipeline support
- Proc-based dynamic namespaces
- Deprecation warnings for administrative commands
- Environment variable configuration (VALKEY_NAMESPACE_QUIET, VALKEY_NAMESPACE_DEPRECATIONS)

### Notes
- Based on redis-namespace architecture
- Designed as a drop-in replacement for redis-namespace when using Valkey
