# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

source "https://rubygems.org"

gemspec

group :maintenance, optional: true do
	gem "bake-modernize"
	gem "bake-bundler"
	
	gem "utopia-project"
end

gem "decode", "~> 0.30.0", group: :maintenance

gem "rubocop", "~> 1.91", group: :test
gem "rubocop-md", "~> 2.0", group: :test
gem "rubocop-socketry", "~> 0.11.1", group: :test

group :test do
	gem "sus"
	gem "covered"
	gem "bake-test"
end

# Moved Development Dependencies
gem "bake"

gem "bake-releases", "~> 0.5.4", group: :maintenance
