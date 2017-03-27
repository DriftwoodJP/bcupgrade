require_relative 'bcupgrade/version'
require_relative 'bcupgrade/brew_cask'
require_relative 'bcupgrade/cask'

module Bcupgrade
  def self.check_version(cask)
    cask_info = BrewCask.info(cask)
    lines = cask_info.split(/\n/)
    latest_version = if lines[0].nil?
                       'error'
                     else
                       lines[0].gsub(/.+: (.+)/, '\1')
                     end
    installed_path = "#{BrewCask::CASKROOM_PATH}/#{cask}/#{latest_version}"

    cask_info.include?(installed_path) ? nil : latest_version
  end

  def self.upgrade(casks)
    casks.each do |cask|
      input = Readline.readline("\nUpgrade #{cask}? [y/n] ")
      next unless input == 'y'
      puts "remove #{cask}"
      BrewCask.remove(cask)
      puts "install #{cask}"
      BrewCask.install(cask)
    end
  end

  def self.run(options)
    cask = Cask.new

    # Check cask list
    puts "\n==> Check 'brew cask list'...\n"

    cask_list = cask.list
    installed_casks = cask_list[0]
    error_casks = cask_list[1]

    puts "#{installed_casks}\n"
    unless error_casks == []
      puts "\nSkip re-install: can't found brew cask info\n#{error_casks}\n"
    end

    # Check cask version
    puts "\n==> Check 'brew cask info' for the latest available version...\n"

    update_casks = []
    installed_casks.each do |name|
      latest_version = check_version(name)
      if latest_version
        puts "#{name} / #{latest_version}"
        update_casks.push(name)
      end
    end

    # Upgrade cask
    if update_casks.any?
      upgrade(update_casks) unless options[:dry_run]
    else
      puts "\nAlready up-to-date."
    end
  end
end
