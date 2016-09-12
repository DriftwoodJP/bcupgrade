require 'bcupgrade/version'

module Bcupgrade
  def self.check_update(casks)
    update_casks = []
    casks.each do |cask|
      info = `brew cask info #{cask}`
      lines = info.split(/\n/)
      version = lines[0].gsub(/.+: (.+)/, '\1')

      installed_path = "/usr/local/Caskroom/#{cask}/#{version}"
      update_casks.push(cask) unless info.include?(installed_path)
    end
    update_casks
  end
end
