# frozen_string_literal: true

require 'yaml'

module Bcupgrade
  class Cask
    attr_reader :config, :args, :target

    def initialize(options, args)
      @config  = load_config
      @options = options
      @args    = args.uniq
      @target  = upgrade_target
    end

    def upgrade_version(casks)
      return if @options[:dry_run]

      casks.each do |cask|
        next unless prompt_answer_yes?(cask)

        puts "\n==> Upgrade #{cask}"
        BrewCask.install(cask)
      end
    end

    private

    def load_config
      file = File.join(ENV['HOME'], '.bcupgrade')
      YAML.load_file(file) if File.exist?(file)
    end

    def upgrade_target
      if @args.any?
        @args
      else
        outdated = BrewCask.outdated.split(/\n/)
        exclude_ignore_casks(outdated)
      end
    end

    def exclude_ignore_casks(casks)
      if @config.nil?
        casks
      else
        ignore = Array(@config['ignore'])
        casks - ignore
      end
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
