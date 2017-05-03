# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Migrate
	class Controller
		def initialize
			@migrations = {}
		end
		
		attr :migrations
		
		# Apply the given migration.
		def apply(migration)
			start_time = Time.now
			
			yield
			
			duration = Time.now - start_time
			
			commit(migration)
		end
		
		# Persist that the migration was applied.
		def commit(migration)
			@migrations[migration.name] = migration
		end
		
		def << migrations
			migrations.each do |migration|
				apply(migration) do
					migration.call(self)
				end unless @migrations.include?(migration)
			end
		end
	end
	
	class FileController
		def initialize(root)
			@root = root
			
			super()
		end
		
		def migrations
			@migrations ||= load_migrations
		end
		
		def load_migrations
			
		end
	end
end
