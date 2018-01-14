# frozen_string_literal: true

require 'yaml'

module Bcupgrade
  class Cask
    attr_reader :args

    def initialize(options, args, config)
      @config   = config
      @options  = options
      @args     = args.uniq
      @outdated = BrewCask.outdated.split(/\n/)
    end

    def upgrade(casks)
      return if @options[:dry_run]

      casks.each do |cask|
        next unless prompt_answer_yes?(cask)

        puts "\n==> Upgrade #{cask}"
        BrewCask.install(cask)
      end
    end

    def list_ignore
      @config.ignore.join(' ')
    end

    def upgrade_target
      if @args.any?
        @args
      else
        exclude_ignore_casks(@outdated)
      end
    end

    private

    def exclude_ignore_casks(casks)
      casks - @config.ignore
    end

    def prompt_answer_yes?(cask)
      input = if @options[:install]
                'y'
              else
                Readline.readline("\nUpgrade #{cask}? [y/n] ")
              end
      if input.casecmp('y').zero? || input.casecmp('yes').zero?
        true
      else
        false
      end
    end
  end
end
