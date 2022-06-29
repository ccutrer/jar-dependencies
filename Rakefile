# frozen_string_literal: true

task default: [:specs]

desc "run specs"
task :specs do
  $LOAD_PATH << "specs"

  Dir["specs/*_spec.rb"].each do |f|
    require File.basename(f.sub(/.rb$/, ""))
  end
end
