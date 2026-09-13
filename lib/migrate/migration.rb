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
		
		def call(controller)
			self.instance_eval(::File.read(@path), @path)
		end
		
		def migrate(target, using:, name: self.name, **options, &block)
			using.migrate(name, target, **options, &block)
		end
		
		def to_s
			@name
		end
		
		def <=> other
			@name <=> other.name
		end
	end
end
