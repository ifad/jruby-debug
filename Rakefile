require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/clean'

CLEAN.include('ext')
CLEAN.include('lib/ruby_debug.jar')

task :default => :test

# Extension
#
require 'rake/javaextensiontask' # rake-compiler
Rake::JavaExtensionTask.new('ruby_debug') do |t|
  t.ext_dir = "src"
end

# RDoc
#
require 'rdoc/task'
RDoc::Task.new do |t|
  t.main = 'README'
  t.rdoc_files.include 'README'
end

# Tests
#
require 'rake/testtask'

BASE_TEST_FILE_LIST = %w(
  test/base/base.rb
  test/base/binding.rb
  test/base/catchpoint.rb)

CLI_TEST_FILE_LIST = 'test/test-*.rb'

desc "Test ruby-debug-base."
task :test_base => :lib do
  Rake::TestTask.new(:test_base) do |t|
    t.ruby_opts << "--debug"
    t.libs << './ext'
    t.libs << './lib'
    t.test_files = FileList[BASE_TEST_FILE_LIST]
    t.verbose = true
  end
end

desc "Test everything."
task :test => :test_base do
  Rake::TestTask.new(:test) do |t|
    t.ruby_opts << "--debug"
    t.libs << './ext'
    t.libs << './lib'
    t.libs << './cli'
    t.pattern = CLI_TEST_FILE_LIST
    t.verbose = true
  end
end

RUBY_DEBUG_PROJECT = 'https://github.com/ruby-debug/ruby-debug/blob/master'

desc "Helps to setup the project to be able to run tests"
task :prepare_tests do
  # needed to run CLI test. Unable to use svn:externals yet:
  #   http://subversion.tigris.org/issues/show_bug.cgi?id=937

  # rdbg.rb
  sh "curl #{RUBY_DEBUG_PROJECT}/rdbg.rb > rdbg.rb" unless File.exists?('rdbg.rb')

  # runner.sh
  runner = 'runner.sh'
  sh "curl #{RUBY_DEBUG_PROJECT}/#{runner} > #{runner}" unless File.exists?('runner.sh')
  text = File.read('runner.sh')
  File.open(runner, 'w') {|f| f.write(text.gsub(/-ruby/ , '-jruby --debug'))}
  File.chmod(0755, runner)

  mkdir 'test' unless File.exist? 'test'
  File.open('test/config.private.yaml', 'w') do |f|
    f.write <<EOF
# either should be on the $PATH or use full path
ruby: jruby

# possibility to specify interpreter parameters
ruby_params: --debug
EOF
  end

  require './lib/jruby-debug/version'

  # - prepare default customized test/config.private.yaml suitable for JRuby
  # - tweak test suite to be able to pass for jruby-debug-base which does not
  #   support e.g. TraceLineNumbers yet.
  sh "patch -p0 < patch-#{JRubyDebug::VERSION}.diff"
end
