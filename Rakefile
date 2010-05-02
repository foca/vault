require "rake"

begin
  require "spec/rake/spectask"

  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.pattern = "spec/**/*_spec.rb"
    spec.spec_opts << "--color" << "--format specdoc"
  end

  task :default => ["spec"]
rescue LoadError
end
