module Bcupgrade
  module BrewCask
    def self.list
      `brew cask list`
    end

    def self.info(cask)
      `brew cask info #{cask}`
    end

    def self.remove(cask)
      system "brew cask uninstall --force #{cask}"
    end

    def self.install(cask)
      system "brew cask install --force #{cask}"
    end
  end
end
