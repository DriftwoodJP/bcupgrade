# frozen_string_literal: true

module Bcupgrade
  module BrewCask
    def self.outdated
      `brew outdated --quiet --cask`
    end

    def self.output_outdated
      system 'brew outdated --cask'
    end

    def self.install(cask)
      system "brew reinstall --cask #{cask}"
    end
  end
end
