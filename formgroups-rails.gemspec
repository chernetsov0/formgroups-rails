$:.push File.expand_path("../lib", __FILE__)

require "form_groups/version"

Gem::Specification.new do |s|
  s.name        = "formgroups-rails"
  s.version     = FormGroups::VERSION
  s.authors     = ["Alexey Chernetsov"]
  s.email       = ["chernetsov0@gmail.com"]
  s.homepage    = "http://github.com/chernetsov0/formgroups-rails"
  s.summary     = "FormBuilder extensions for Rails"
  s.description = "This gem for Ruby on Rails 4.0+ allows to create blocks for each field of the form.
This allows to simplify syntax, show errors, add errors classes and validation attributes."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "thin"
  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
end
