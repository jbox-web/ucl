# frozen_string_literal: true

require_relative 'lib/ucl/version'

Gem::Specification.new do |s|
  s.name        = 'ucl'
  s.version     = UCL::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/ucl'
  s.summary     = 'LibUCL FFI bindings for Ruby'
  s.license     = 'MIT'
  s.metadata    = {
    'homepage_uri'    => 'https://github.com/jbox-web/ucl',
    'changelog_uri'   => 'https://github.com/jbox-web/ucl/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/jbox-web/ucl',
    'bug_tracker_uri' => 'https://github.com/jbox-web/ucl/issues'
  }

  s.required_ruby_version = '>= 2.6.0'

  s.files = `git ls-files`.split("\n")

  s.extensions << 'ext/Rakefile'

  s.add_runtime_dependency 'ffi'
  s.add_runtime_dependency 'zeitwerk'

  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rake'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
end
