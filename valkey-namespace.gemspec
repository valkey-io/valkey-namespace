lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'valkey/namespace/version'

Gem::Specification.new do |s|
  s.name              = "valkey-namespace"
  s.version           = Valkey::Namespace::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Namespaces Valkey commands."
  s.homepage          = "https://github.com/valkey-io/valkey-namespace"
  s.email             = ["maintainer@example.com"]
  s.authors           = ["Valkey Community"]
  s.license           = 'MIT'

  s.metadata = {
    "bug_tracker_uri"       => "https://github.com/valkey-io/valkey-namespace/issues",
    "changelog_uri"         => "https://github.com/valkey-io/valkey-namespace/blob/master/CHANGELOG.md",
    "documentation_uri"     => "https://www.rubydoc.info/gems/valkey-namespace/#{s.version}",
    "source_code_uri"       => "https://github.com/valkey-io/valkey-namespace",
    "homepage_uri"          => "https://github.com/valkey-io/valkey-namespace",
    "rubygems_mfa_required" => "true"
  }

  s.files             = %w( README.md Rakefile LICENSE NOTICE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("test/**/*")
  s.files            += Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 2.7'

  s.add_dependency    "valkey-rb", ">= 1.0.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "connection_pool"

  s.description = <<description
Adds a Valkey::Namespace class which can be used to namespace calls
to Valkey. This is useful when using a single instance of Valkey with
multiple, different applications.
description
end
