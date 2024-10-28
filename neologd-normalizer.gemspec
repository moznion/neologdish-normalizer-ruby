# frozen_string_literal: true

require_relative "lib/neologdish/normalizer/version"

Gem::Specification.new do |spec|
  spec.name = "neologdish-normalizer"
  spec.version = Neologdish::Normalizer::VERSION
  spec.authors = ["moznion"]
  spec.email = ["moznion@mail.moznion.net"]

  spec.summary = "A Japanese text normalization library follows the conventions of neologd"
  spec.description = "A Japanese text normalization library follows the conventions of neologd with some performance optimizations. It is designed to preprocess Japanese text before applying NLP techniques."
  spec.homepage = "https://github.com/moznion/neologdish-normalizer"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/moznion/neologdish-normalizer"
  spec.metadata["changelog_uri"] = "https://github.com/moznion/neologdish-normalizer/releases"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ scripts/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "moji"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rbs-inline"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "minitest"
end
