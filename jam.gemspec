# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "jam.rb"
  s.version = "0.0.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eduard Tsech"]
  s.email       = ["edtsech@gmail.com"]
  s.homepage    = ""
  s.summary     = "JSON Api Maker."
  s.description = "JSON Api Maker."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
end
