require_relative 'bcupgrade/version'
require_relative 'bcupgrade/brew_cask'
require_relative 'bcupgrade/cask'

module Bcupgrade
  def self.run(options, args)
    cask = Cask.new(options, args)

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
      latest_version = Cask.check_version(name)
      if latest_version
        puts "#{name} / #{latest_version}"
        update_casks.push(name)
      end
    end

    # Upgrade cask
    if update_casks.any?
      unless options[:dry_run]
        Cask.upgrade(update_casks)
      end
    else
      puts "\nAlready up-to-date."
    end
  end
end
