require 'bcupgrade/version'
require 'bcupgrade/brew_cask'

module Bcupgrade
  def self.check_list
    cask_list = Bcupgrade.brew_cask_list.split("\n")

    installed_casks = []
    error_casks = []
    cask_list.each do |cask|
      if cask.include?(' (!)')
        error_casks.push(cask.delete(' (!)'))
      else
        installed_casks.push(cask)
      end
    end

    [installed_casks, error_casks]
  end

  def self.check_version(cask)
    cask_info = Bcupgrade.brew_cask_info(cask)
    lines = cask_info.split(/\n/)
    latest_version = if lines[0].nil?
                       'error'
                     else
                       lines[0].gsub(/.+: (.+)/, '\1')
                     end
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
    puts "\n==> Check 'brew cask list'...\n"
    cask_list = Bcupgrade.check_list
    installed_casks = cask_list[0]
    error_casks = cask_list[1]

    puts "#{installed_casks}\n"

    unless error_casks == []
      puts "\nSkip re-install: can't found brew cask info\n#{error_casks}\n"
    end

    # Check cask version
    puts "\n==> Check 'brew cask info' for the latest available version...\n"
    update_casks = []
    installed_casks.each do |cask|
      latest_version = Bcupgrade.check_version(cask)
      if latest_version
        puts "#{cask} / #{latest_version}"
        update_casks.push(cask)
      end
    end

    # Upgrade cask
    if update_casks.any?
      Bcupgrade.upgrade(update_casks) if option
    else
      puts "\nAlready up-to-date."
    end
  end
end
