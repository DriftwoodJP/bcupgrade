module Bcupgrade
  CASKROOM_PATH = '/usr/local/Caskroom'

  def self.brew_cask_list
    `brew cask list`
  end

  def self.brew_cask_info(cask)
    `brew cask info #{cask}`
  end
end
