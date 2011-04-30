# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gsd}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evan Worley", "Richard Taylor"]
  s.date = "2011-04-30"
  s.description = "gsd is a Ruby client library for the Google Storage API, based on moomerman's gstore gem."
  s.email = "evanworley@gmail.com"
  s.files = ["LICENSE", "README.textile","lib/gsd.rb"] + Dir.glob('lib/gsd/*.rb')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/evanworley/gsd}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gsd}
  s.rubygems_version = %q{1.3.1}
  s.summary = "gsd is a Ruby client library for the Google Storage API, based on moomerman's gstore gem."

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
    s.add_dependency("libxml-ruby", [">= 2.0.2"])
  else
    s.add_dependency("libxml-ruby", [">= 2.0.2"])
  end
end
