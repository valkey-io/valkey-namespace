valkey-namespace
===============

Valkey::Namespace provides an interface to a namespaced subset of your [Valkey][] keyspace (e.g., keys with a common beginning), and requires the [valkey-glide-ruby][] gem.

```ruby
require 'valkey-namespace'
# => true

valkey_connection = Valkey.new
# => #<Valkey client>
namespaced_valkey = Valkey::Namespace.new(:ns, valkey: valkey_connection)
# => #<Valkey::Namespace v1.0.0 with client for ns>

namespaced_valkey.set('foo', 'bar') # valkey_connection.set('ns:foo', 'bar')
# => "OK"

# Valkey::Namespace automatically prepended our namespace to the key
# before sending it to our valkey client.

namespaced_valkey.get('foo')
# => "bar"
valkey_connection.get('foo')
# => nil
valkey_connection.get('ns:foo')
# => "bar"

namespaced_valkey.del('foo')
# => 1
namespaced_valkey.get('foo')
# => nil
valkey_connection.get('ns:foo')
# => nil
```

Valkey::Namespace also supports `Proc` as a namespace and will take the result string as namespace at runtime.

```ruby
valkey_connection = Valkey.new
namespaced_valkey = Valkey::Namespace.new(Proc.new { Tenant.current_tenant }, valkey: valkey_connection)
```

Installation
============

Valkey::Namespace is packaged as the valkey-namespace gem, and hosted on rubygems.org.

From the command line:

    $ gem install valkey-namespace

Or in your Gemfile:

```ruby
gem 'valkey-namespace'
```

Caveats
=======

`Valkey::Namespace` provides a namespaced interface to `Valkey` by keeping an internal registry of the method signatures in `Valkey` provided by the [valkey-glide-ruby][] gem; we keep track of which arguments need the namespace added, and which return values need the namespace removed.

Blind Passthrough
-----------------
If your version of this gem doesn't know about a particular command, it can't namespace it. Historically, this has meant that Valkey::Namespace blindly passes unknown commands on to the underlying valkey connection without modification which can lead to surprising effects.

As of v1.0.0, blind passthrough has been deprecated, and the functionality will be removed entirely in 2.0.

If you come across a command that is not yet supported, please open an issue on the [issue tracker][] or submit a pull-request.

Administrative Commands
-----------------------
The effects of some valkey commands cannot be limited to a particular namespace (e.g., `FLUSHALL`, which literally truncates all databases in your valkey server, regardless of keyspace). Historically, this has meant that Valkey::Namespace intentionally passes administrative commands on to the underlying valkey connection without modification, which can lead to surprising effects.

As of v1.0.0, the direct use of administrative commands has been deprecated, and the functionality will be removed entirely in 2.0; while such commands are often useful for testing or administration, their meaning is inherently hidden when placed behind an interface that implies it will namespace everything.

The preferred way to send an administrative command is on the valkey connection itself, which is publicly exposed as `Valkey::Namespace#valkey`:

```ruby
namespaced.valkey.flushall()
# => "OK"
```

2.x Planned Breaking Changes
============================

As mentioned above, 2.0 will remove blind passthrough and the administrative command passthrough.
By default in 1.0+, deprecation warnings are present and enabled;
they can be silenced by initializing `Valkey::Namespace` with `warning: false` or by setting the `VALKEY_NAMESPACE_QUIET` environment variable.

Early opt-in
------------

To enable testing against the 2.x interface before its release, in addition to deprecation warnings, early opt-in to these changes can be enabled by initializing `Valkey::Namespace` with `deprecations: true` or by setting the `VALKEY_NAMESPACE_DEPRECATIONS` environment variable.
This should only be done once all warnings have been addressed.

Compatibility
=============

This gem is designed to work with [valkey-glide-ruby][], which provides a drop-in replacement for redis-rb. It supports all Valkey commands and is API-compatible with Redis 6.2, 7.0, 7.1, and 7.2.

Authors
=======

This project is based on [redis-namespace][] and adapted for Valkey.

Original redis-namespace authors who contributed significantly:
 - Chris Wanstrath (@defunkt)
 - Ryan Biesemeyer (@yaauie)
 - Steve Klabnik (@steveklabnik)
 - Terence Lee (@hone)
 - Eoin Coffey (@ecoffey)

valkey-namespace adaptation:
 - Valkey Community

## License

This project is licensed under the MIT License, the same as redis-namespace.
See the LICENSE file for details.

## Acknowledgments

Special thanks to the redis-namespace project and its contributors for creating
the original implementation that this project is based on.

[Valkey]: https://valkey.io
[valkey-glide-ruby]: https://github.com/valkey-io/valkey-glide-ruby
[redis-namespace]: https://github.com/resque/redis-namespace
[issue tracker]: https://github.com/valkey-io/valkey-namespace/issues
