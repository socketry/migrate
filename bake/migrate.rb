# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021, by Samuel Williams.

# @parameter paths [Array] Only apply the specified migrations.
def migrate(paths: nil)
	require "migrate/controller"
	
	controller = Migrate::Controller.new
	
	controller.migrate!
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
