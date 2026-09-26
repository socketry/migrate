# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

module Migrate
	class Migration
		def initialize(path)
			@path = path
			@name = path.relative_path
		end
		
		attr :name
		
		# Whether this migration is a checkpoint, identified by the `checkpoint` marker in its name.
		def checkpoint?
			@name.include?("checkpoint")
		end
		
		def call(controller)
			self.instance_eval(::File.read(@path), @path)
		end
		
		# Run the migration as a delta, using the specified migrator.
		def migrate(target, using:, name: self.name, **options, &block)
			using.migrate(name, target, **options, &block)
		end
		
		# Run the migration as a checkpoint (a full snapshot of state), using the specified migrator.
		def checkpoint(target, using:, name: self.name, **options, &block)
			using.checkpoint(name, target, **options, &block)
		end
		
		def to_s
			@name
		end
		
		def <=> other
			@name <=> other.name
		end
	end
end
