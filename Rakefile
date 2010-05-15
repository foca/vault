$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "rake"
require "rake/gempackagetask"
require "rake/rdoctask"

require "vault/version"

begin
  require "spec/rake/spectask"

  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.pattern = "spec/**/*_spec.rb"
    spec.spec_opts << "--color" << "--format specdoc"
  end

  task :default => ["spec"]
rescue LoadError
end

spec = Gem::Specification.new do |s|
  s.name              = "vault"
  s.version           = Vault::Version::STRING
  s.summary           = "Provides a very lightweight ODM"
  s.author            = "Nicolás Sanguinetti"
  s.email             = "hi@nicolassanguinetti.info"
  s.homepage          = "http://github.com/foca/vault"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.md MIT-LICENSE)

  s.files             = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', '*LICENSE*'] & `git ls-files -z`.split("\0")

  s.require_paths     = ["lib"]

  s.add_dependency("activemodel",   "3.0.0.beta3")
  s.add_dependency("activesupport", "3.0.0.beta3")

  s.add_development_dependency("rspec", "~> 1.3")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
