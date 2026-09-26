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
		
		# Apply the migrations to the current state.
		#
		# @parameter checkpoint [TrueClass | String] If `true`, apply the most recent checkpoint and then only the migrations which sort after it. If a string, apply the checkpoint with that name. If absent, apply all migrations, ignoring checkpoints.
		def migrate!(checkpoint: nil)
			list = migrations
			checkpoints = list.select(&:checkpoint?)
			
			if checkpoint
				base =
					checkpoint == true ? checkpoints.last :
					checkpoints.find do |candidate|
						candidate.name == checkpoint
					end
				raise RuntimeError, "No checkpoint found for #{checkpoint.inspect}." if base.nil?
				
				# Apply the checkpoint then the migrations which sort after it:
				self.run([base] + list[list.index(base) + 1..].reject(&:checkpoint?))
			else # No checkpoint: apply all non-checkpoint migrations:
				self.run(list.reject(&:checkpoint?))
			end
		end
		
		def create!(name, &block)
			prefix = Time.now.strftime("%Y%m%d%H%M%S")
			path = @root / "#{prefix}-#{name}.rb"
			path.parent.mkpath
			
			path.open(File::CREAT|File::TRUNC|File::WRONLY, &block)
			
			return path
		end
		
		private
		
		def run(migrations)
			migrations.each do |migration|
				Console.logger.debug(self, "Applying...", migration: migration)
				migration.call(self)
			end
		end
	end
end
