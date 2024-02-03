# frozen_string_literal: true

require_relative "lib/weighted_list_rank/version"

Gem::Specification.new do |spec|
  spec.name = "weighted_list_rank"
  spec.version = WeightedListRank::VERSION
  spec.authors = ["Shane Sherman"]
  spec.email = ["shane.sherman@gmail.com"]

  spec.summary = "generate ranks of items from weighted lists"
  spec.description = "generate ranks of items from weighted lists"
  spec.homepage = "https://github.com/ssherman/weighted_list_rank"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ssherman/weighted_list_rank"
  spec.metadata["changelog_uri"] = "https://github.com/ssherman/weighted_list_rank/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "rubocop-minitest", "~> 0.3"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
