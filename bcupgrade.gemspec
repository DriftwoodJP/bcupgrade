# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bcupgrade/version'

Gem::Specification.new do |spec|
  spec.name                  = 'bcupgrade'
  spec.version               = Bcupgrade::VERSION
  spec.authors               = ['DriftwoodJP']
  spec.email                 = ['DriftwoodJP@users.noreply.github.com']

  spec.summary               = 'Upgrade all installed brew casks.'
  spec.description           = 'Upgrade all installed brew casks.'
  spec.homepage              = 'https://github.com/DriftwoodJP/bcupgrade'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.0.0.648'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files                 = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir                = 'exe'
  spec.executables           = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths         = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16.0'
  spec.add_development_dependency 'rake', '~> 12.3.0'
  spec.add_development_dependency 'rspec', '~> 3.7.0'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.20.1'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'pry-byebug', '~> 3.5.0'
end
