# frozen_string_literal: true

require 'rake/testtask'

CODE = 'app/controllers'

task :default do
  sh 'bundle exec puma'
end

task :test do
  sh 'rspec spec/app_spec.rb'
end

task :spec do
  ruby 'spec/spec_helper.rb'
end

namespace :vcr do
  desc 'delete all cassettes'
  task :delete do
    rm_rf 'spec/fixtures/cassettes'
  end
end

namespace :quality do
  desc 'run all quality checks'
  task all: %i[rubocop reek flog]
  task :rubocop do
    sh 'rubocop'
  end
  task :reek do
    sh 'reek'
  end
  task :flog do
    sh "flog#{CODE}"
  end
end
