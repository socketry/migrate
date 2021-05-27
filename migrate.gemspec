
require_relative "lib/migrate/version"

Gem::Specification.new do |spec|
	spec.name = "migrate"
	spec.version = Migrate::VERSION
	
	spec.summary = "Generic library to support migrations."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/socketry/migrate"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{bake,lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.add_dependency "build-files", "~> 1.7"
	
	spec.add_development_dependency "bake"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "rspec", "~> 3.0"
end
