# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

require "migrate"
require "tmpdir"

class FakeMigrator
	def self.migrate(name, target, **options, &block)
		@call = [name, target, options, block&.call]
	end
	
	def self.call
		@call
	end
end

describe Migrate::Controller do
	let(:root) {Build::Files::Path.join(__dir__, "../../fixtures/project/migrate")}
	let(:controller) {subject.new(root)}
	
	it "can list migrations" do
		expect(controller.migrations).not.to be(:empty?)
	end
	
	it "has a default root" do
		expect(subject.root.to_s).to be =~ /migrate$/
	end
	
	with "temporary migration root" do
		around do |&block|
			Dir.mktmpdir do |root|
				@root = Build::Files::Path.new(root)
				block.call
			end
		end
		
		let(:controller) {subject.new(@root)}
		
		def write_migration(name, content)
			path = @root / name
			path.parent.mkpath
			::File.write(path, content)
			path
		end
		
		it "can create a migration" do
			path = controller.create!("create_users") do |file|
				file.write("# migration\n")
			end
			
			expect(path.basename.to_s).to be =~ /\A\d{14}-create_users\.rb\z/
			expect(path.read).to be == "# migration\n"
		end
		
		it "can apply migrations" do
			marker = @root / "marker.txt"
			write_migration("1_test_migration.rb", "File.write(#{marker.to_s.dump}, self.to_s)\n")
			
			controller.migrate!
			
			expect(marker.read).to be == "1_test_migration.rb"
		end
		
		it "can invoke a migrator" do
			path = write_migration("2_test_migration.rb", "")
			migration = Migrate::Migration.new(path)
			
			migration.migrate(:database, using: FakeMigrator, mode: :test) do
				:result
			end
			
			expect(FakeMigrator.call).to be == ["2_test_migration.rb", :database, {mode: :test}, :result]
		end
		
		it "can override the migration name" do
			path = write_migration("3_test_migration.rb", "")
			migration = Migrate::Migration.new(path)
			
			migration.migrate(:database, using: FakeMigrator, name: "custom_name") do
				:result
			end
			
			expect(FakeMigrator.call).to be == ["custom_name", :database, {}, :result]
		end
	end
end
