require 'yaml'
require_relative 'bcupgrade/version'
require_relative 'bcupgrade/brew_cask'

module Bcupgrade
  def self.load_config
    file = File.join(ENV['HOME'], '.bcupgrade')
    YAML.load_file(file) if File.exist?(file)
  end

  def self.installed_casks(casks, config)
    if config.nil?
      casks
    else
      casks - Array(config['ignore'])
    end
  end

  def self.check_list
    cask_list = BrewCask.list.split("\n")

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
    config = load_config

    # Check cask list
    puts "\n==> Check 'brew cask list'...\n"

    cask_list = check_list
    installed_casks = installed_casks(cask_list[0], config)
    error_casks = cask_list[1]

    puts "#{installed_casks}\n"

    unless error_casks == []
      puts "\nSkip re-install: can't found brew cask info\n#{error_casks}\n"
    end

    # Check cask version
    puts "\n==> Check 'brew cask info' for the latest available version...\n"

    update_casks = []
    installed_casks.each do |cask|
      latest_version = check_version(cask)
      if latest_version
        puts "#{cask} / #{latest_version}"
        update_casks.push(cask)
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
