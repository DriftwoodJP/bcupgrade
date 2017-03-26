module Bcupgrade
  module BrewCask
    CASKROOM_PATH = '/usr/local/Caskroom'.freeze

    def self.brew_cask_list
      `brew cask list`
    end

    def self.brew_cask_info(cask)
      `brew cask info #{cask}`
    end

    def self.brew_cask_remove(cask)
      system "rm -rf #{CASKROOM_PATH}/#{cask}"
    end

    def self.brew_cask_install(cask)
      system "brew cask install --force #{cask}"
    end
  end
end
