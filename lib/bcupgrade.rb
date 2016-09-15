require 'bcupgrade/version'
require 'bcupgrade/brew_cask'

module Bcupgrade
  def self.check_list
    Bcupgrade.brew_cask_list.delete(' (!)').split("\n")
  end

  def self.check_version(cask)
    cask_info = Bcupgrade.brew_cask_info(cask)
    lines = cask_info.split(/\n/)
    latest_version = lines[0].gsub(/.+: (.+)/, '\1')
    installed_path = "#{Bcupgrade::CASKROOM_PATH}/#{cask}/#{latest_version}"

    cask_info.include?(installed_path) ? nil : latest_version
  end

  def self.upgrade(casks)
    casks.each do |cask|
      input = Readline.readline("\nUpgrade #{cask}? [y/n] ")
      next unless input == 'y'
      puts "remove #{cask}"
      Bcupgrade.brew_cask_remove(cask)
      puts "install #{cask}"
      Bcupgrade.brew_cask_install(cask)
    end
  end

  def self.run(option = false)
    # Check cask list
    puts "\nCheck brew cask list...\n"
    installed_casks = Bcupgrade.check_list
    puts "#{installed_casks}\n"

    # Check cask version
    puts "\nCheck the latest available version...\n"
    update_casks = []
    installed_casks.each do |cask|
      latest_version = Bcupgrade.check_version(cask)
      if latest_version
        puts "#{cask} / #{latest_version}"
        update_casks.push(cask)
      end
    end

    if option
      # Upgrade cask
      if update_casks.any?
        Bcupgrade.upgrade(update_casks)
      else
        puts "\nAlready up-to-date."
      end
    end
  end
end
