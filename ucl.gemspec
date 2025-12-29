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
    'bug_tracker_uri' => 'https://github.com/jbox-web/ucl/issues',
  }

  s.required_ruby_version = '>= 3.2.0'

  s.files = Dir['README.md', 'CHANGELOG.md', 'LICENSE', 'lib/**/*.rb', 'lib/**/*.rake', 'ext/Rakefile']

  s.extensions << 'ext/Rakefile'

  s.add_dependency 'ffi'
  s.add_dependency 'zeitwerk'
end
