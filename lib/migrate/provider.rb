# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021, by Samuel Williams.

module Migrate
	class Provider
		def migrate(migration, target, **options, &block)
			yield
		end
		
		def checkpoint(migration, target, **options, &block)
			raise NotImplementedError, "Subclasses must implement #checkpoint."
		end
	end
end
