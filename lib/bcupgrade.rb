require 'bcupgrade/version'
require 'bcupgrade/brew_cask'

module Bcupgrade
  def self.check_list
    Bcupgrade::brew_cask_list.delete(' (!)').split("\n")
  end

  def self.check_version(casks)
    update_casks = []
    casks.each do |cask|
      cask_info = Bcupgrade::brew_cask_info(cask)
      lines = cask_info.split(/\n/)
      version = lines[0].gsub(/.+: (.+)/, '\1')

      installed_path = "#{Bcupgrade::CASKROOM_PATH}/#{cask}/#{version}"
      update_casks.push(cask) unless cask_info.include?(installed_path)
    end
    update_casks
  end

  def self.upgrade(casks)
    casks.each do |cask|
      input = Readline.readline("\nUpgrade #{cask}? [y/n] ")
      next unless input == 'y'
      puts "remove #{cask}"
      system "rm -rf #{Bcupgrade::CASKROOM_PATH}/#{cask}"
      puts "install #{cask}"
      system "brew cask install --force #{cask}"
    end
  end

  def self.run(option = false)
    # Check cask list
    puts "\nCheck cask list...\n"
    installed_casks = Bcupgrade.check_list
    puts "#{installed_casks}\n"

    # Check cask version
    puts "\nCheck cask version...\n"
    update_casks = Bcupgrade.check_version(installed_casks)
    puts "#{update_casks}\n"

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
