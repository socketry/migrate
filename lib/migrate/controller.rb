# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

require "console"
require "build/files"
require "pathname"

require_relative "migration"

module Migrate
	class Controller
		def self.root(dir = Dir.pwd)
			Pathname.new(dir) / "migrate"
		end
		
		def initialize(root = self.class.root)
			@root = root
		end
		
		def migrations
			@root.glob("**/*.rb").map{|path| Migration.new(path)}.sort
		end
		
		def migrate!
			migrations.each do |migration|
				Console.logger.debug(self, "Applying...", migration: migration)
				migration.call(self)
			end
		end
		
		def create!(name, &block)
			prefix = Time.now.strftime("%Y%m%d%H%M%S")
			path = @root / "#{prefix}-#{name}.rb"
			path.parent.mkpath
			
			path.open(File::CREAT|File::TRUNC|File::WRONLY, &block)
			
			return path
		end
	end
end
