# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

def call(controller)
	paths = controller.root.glob("**/*.xnode")
	
	paths.each do |path|
		buffer = path.read
		
		buffer.gsub(/attributes\[["'](.*?)["']\]/, "attributes[:$1]")
		
		path.write(buffer)
	end
end
