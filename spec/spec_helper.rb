# frozen_string_literal: true

require 'simplecov'
require 'rspec'
require 'active_support/core_ext/integer'

# Start Simplecov
SimpleCov.start do
  add_filter 'spec/'
end

# Configure RSpec
RSpec.configure do |config|
  config.color = true
  config.fail_fast = false

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!
end

def get_fixture_path(name)
  File.expand_path("fixtures/#{name}", __dir__)
end

require 'ucl'
