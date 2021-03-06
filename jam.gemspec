# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "jam-ruby"
  s.version     = "0.0.10"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Edward Tsech"]
  s.email       = ["edtsech@gmail.com"]
  s.homepage    = "https://github.com/edtsech/jam"
  s.summary     = "JSON Api Maker."
  s.description = "Simple, readable and flexible JSON Api Maker based on standart rails tools and hash syntax."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
end
