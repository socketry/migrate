# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021, by Samuel Williams.

module Migrate
	class Provider
		def migrate(migration, target, &block)
			yield
		end
	end
end
