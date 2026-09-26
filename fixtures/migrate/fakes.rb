# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025-2026, by Samuel Williams.

class FakeMigrator
	def self.migrate(name, target, **options, &block)
		@call = [name, target, options, block&.call]
	end
	
	def self.call
		@call
	end
end

class FakeCheckpointMigrator
	def self.checkpoint(name, target, **options, &block)
		@call = [name, target, options, block&.call]
	end
	
	def self.call
		@call
	end
end
