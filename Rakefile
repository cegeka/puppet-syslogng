require 'rubygems'
require 'rake'

MODULE_ROOT_DIR = File.expand_path('..', __FILE__)

FileList["#{MODULE_ROOT_DIR}/tasks/**/*.rake"].each { |fn| load fn }

desc "Default task prints the available targets."
task :default do
  sh %{rake -T}
end
