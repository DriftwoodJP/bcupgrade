module Bcupgrade
  module BrewCask
    CASKROOM_PATH = '/usr/local/Caskroom'.freeze

    def self.list
      `brew cask list`
    end

    def self.info(cask)
      `brew cask info #{cask}`
    end

    def self.remove(cask)
      system "rm -rf #{CASKROOM_PATH}/#{cask}"
    end

    def self.install(cask)
      system "brew cask install --force #{cask}"
    end
  end
end
