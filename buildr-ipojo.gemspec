require File.expand_path(File.dirname(__FILE__) + '/lib/buildr/ipojo/version')

Gem::Specification.new do |spec|
  spec.name           = 'buildr-ipojo'
  spec.version        = Buildr::Ipojo::Version::STRING
  spec.authors        = ['Peter Donald']
  spec.email          = ["peter@realityforge.org"]
  spec.homepage       = "http://github.com/realityforge/buildr-ipojo"
  spec.summary        = "Buildr tasks to process OSGi bundles using IPojo"
  spec.description    = <<-TEXT
This is a buildr extension that processes OSGi bundles using the
iPojo "pojoization" tool that generates appropriate metadata from
annotations and a config file.
  TEXT

  spec.files          = Dir['{lib,spec}/**/*', '*.gemspec'] +
                        ['LICENSE', 'README.rdoc', 'CHANGELOG', 'Rakefile']
  spec.require_paths  = ['lib']

  spec.has_rdoc         = true
  spec.extra_rdoc_files = 'README.rdoc', 'LICENSE', 'CHANGELOG'
  spec.rdoc_options     = '--title', "#{spec.name} #{spec.version}", '--main', 'README.rdoc'

  spec.post_install_message = "Thanks for installing the iPojo extension for Buildr"
end
