#
$:.push File.expand_path('../lib', __FILE__)
require 'jruby-debug/version'

Gem::Specification.new do |s|
  s.platform = "java"
  s.summary  = "Java implementation of Fast Ruby Debugger"
  s.name     = 'ruby-debug-base'
  s.version  = JRubyDebug::VERSION
  s.require_path = 'lib'
  s.files    = `git ls-files`.split("\n")
  s.description = <<-EOF

Java extension to make fast ruby debugger run on JRuby.
It is the same what ruby-debug-base is for native Ruby.
EOF

  s.author   = ['debug-commons team', 'Marcello Barnaba']
  s.email    = ["",                   'vjt@openssl.it']
  s.homepage = 'http://github.com/ifad/jruby-debug'
  s.has_rdoc = true

  s.add_development_dependency("rake-compiler")
end
