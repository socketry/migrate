# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

require "migrate"
require "migrate/fakes"
require "tmpdir"

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
		
		def write_checkpoint_migrations
			log = (@root / "log.txt").to_s.dump
			
			append = ->(name) { "File.open(#{log}, \"a\") {|file| file.write(\"#{name}\\n\")}\n" }
			snapshot = "checkpoint(:database, using: FakeCheckpointMigrator, mode: :test) do\n\t:snapshot\nend\n"
			
			write_migration("1_seed_users.rb", append.call("1_seed_users.rb"))
			write_migration("2_checkpoint.rb", "#{append.call("2_checkpoint.rb")}#{snapshot}")
			write_migration("3_add_posts.rb", append.call("3_add_posts.rb"))
			write_migration("4_checkpoint.rb", "#{append.call("4_checkpoint.rb")}#{snapshot}")
			write_migration("5_add_comments.rb", append.call("5_add_comments.rb"))
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
		
		it "can apply all migrations, ignoring checkpoints" do
			write_checkpoint_migrations
			log = @root / "log.txt"
			
			controller.migrate!
			
			expect(log.read).to be == "1_seed_users.rb\n3_add_posts.rb\n5_add_comments.rb\n"
			expect(FakeCheckpointMigrator.call).to be(:nil?)
		end
		
		it "can apply the most recent checkpoint" do
			write_checkpoint_migrations
			log = @root / "log.txt"
			
			controller.migrate!(checkpoint: true)
			
			expect(log.read).to be == "4_checkpoint.rb\n5_add_comments.rb\n"
			expect(FakeCheckpointMigrator.call).to be == ["4_checkpoint.rb", :database, {mode: :test}, :snapshot]
		end
		
		it "can apply a specific checkpoint" do
			write_checkpoint_migrations
			log = @root / "log.txt"
			
			controller.migrate!(checkpoint: "2_checkpoint.rb")
			
			expect(log.read).to be == "2_checkpoint.rb\n3_add_posts.rb\n5_add_comments.rb\n"
		end
		
		it "can raise an error when the checkpoint is not found" do
			write_checkpoint_migrations
			
			expect do
				controller.migrate!(checkpoint: "9_nonexistent_checkpoint.rb")
			end.to raise_exception(RuntimeError, message: be == 'No checkpoint found for "9_nonexistent_checkpoint.rb".')
		end
	end
end
