# frozen_string_literal: true

module Bcupgrade
  module BrewCask
    def self.outdated
      `brew cask outdated --quiet`
    end

    def self.output_outdated
      system 'brew cask outdated'
    end

    def self.install(cask)
      system "brew cask reinstall #{cask}"
    end
  end
end
