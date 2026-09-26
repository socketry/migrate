# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021, by Samuel Williams.

# @parameter paths [Array] Only apply the specified migrations.
# @parameter checkpoint [TrueClass | String] If true, apply the most recent checkpoint and then the migrations which sort after it. If a string, apply the specified checkpoint.
def migrate(paths: nil, checkpoint: nil)
	require "migrate/controller"
	
	controller = Migrate::Controller.new
	
	controller.migrate!(checkpoint: checkpoint)
end

# @parameter name [String] the path for the new migration.
def create(name)
	require "migrate/controller"
	
	controller = Migrate::Controller.new
	
	path = controller.create!(name) do |file|
		file.puts "\# migrate(target, using: Provider) do"
		file.puts "\# end"
	end
	
	Console.logger.info(self, "Created migration at #{path}")
end
