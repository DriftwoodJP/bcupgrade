# frozen_string_literal: true

require_relative 'bcupgrade/version'
require_relative 'bcupgrade/brew_cask'
require_relative 'bcupgrade/cask'
require_relative 'bcupgrade/config_file'

module Bcupgrade
  def self.run(options, args)
    cask = Cask.new(options, args)

    unless cask.args.any?
      puts "\n==> Outdated cask...\n"
      BrewCask.output_outdated

      ignore = cask.config['ignore']
      puts "\nNot upgrading pinned package:\n#{ignore}" if ignore
    end

    update_casks = cask.target
    if update_casks.any?
      cask.upgrade_version(update_casks)
    else
      puts "\nAlready up-to-date."
    end
  end
end
