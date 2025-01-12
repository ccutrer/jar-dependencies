# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "my"
  s.version = "1.1.1"
  s.author = "example person"
  s.email = ["mail@example.com"]
  s.summary = "test gem"

  s.files << Dir["lib/**/*.rb"]
  s.files << Dir["*file"]
  s.files << "my.gemspec"

  s.required_ruby_version = ">= 2.6"

  s.add_runtime_dependency "jar-dependencies"

  s.platform = "java"
  s.requirements << "jar 'com.fasterxml.jackson.core:jackson-core', '2.3.0'"
  s.metadata["rubygems_mfa_required"] = "true"
end
