# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'

  SimpleCov.start do
    enable_coverage :branch
    minimum_coverage line: 95, branch: 95
  end
end

require 'foo'
