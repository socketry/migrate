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

require 'console'
require 'build/files'

require_relative 'migration'

module Migrate
	class Controller
		ROOT = Build::Files::Path.current / "migrate"
		
		def initialize(root = ROOT)
			@root = root
		end
		
		def migrations
			@root.glob("**/*.rb").map{|path| Migration.new(path)}.sort
		end
		
		def migrate!
			migrations.each do |migration|
				Console.logger.debug(self, "Applying #{migration}...")
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
