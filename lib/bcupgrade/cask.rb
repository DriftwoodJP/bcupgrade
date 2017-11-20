# frozen_string_literal: true
require 'yaml'

module Bcupgrade
  class Cask
    attr_reader :installed_casks, :error_casks

    def initialize(options, args)
      @config = config
      @options = options
      @args = args.uniq
      @list = upgrade_target
      @installed_casks = @list[0]
      @error_casks = @list[1]
    end

    def check_version
      update_casks = []

      @installed_casks.each do |name|
        cask_info = BrewCask.info(name)
        version_number = trim_latest_version(cask_info)

        string = "/#{name}/#{version_number}"
        latest_version = cask_info.include?(string) ? nil : version_number

        if latest_version
          puts "#{name} (#{latest_version})"
          update_casks.push(name)
        end
      end

      update_casks
    end

    def upgrade_version(casks)
      return if @options[:dry_run]

      casks.each do |cask|
        input = if @options[:install]
                  'y'
                else
                  Readline.readline("\nUpgrade #{cask}? [y/n] ")
                end
        next unless input == 'y'

        if @options[:remove]
          puts "\n==> Remove #{cask}"
          BrewCask.remove(cask)
        end

        puts "\n==> Install #{cask}"
        BrewCask.install(cask)
      end
    end

    private

    def config
      file = File.join(ENV['HOME'], '.bcupgrade')
      YAML.load_file(file) if File.exist?(file)
    end

    def upgrade_target
      if @args.any?
        trim_target_to_a(@args)
      else
        check_target = trim_target_to_a(BrewCask.list.split(/\n/))
        [trim_ignore_casks(check_target[0]), check_target[1]]
      end
    end

    def trim_target_to_a(array)
      installed_casks = []
      error_casks = []

      array.each do |cask|
        if cask.include?(' (!)')
          error_casks.push(cask.delete(' (!)'))
        else
          installed_casks.push(cask)
        end
      end

      [installed_casks, error_casks]
    end

    def trim_ignore_casks(casks)
      if @config.nil?
        casks
      else
        casks - Array(@config['ignore'])
      end
    end

    def trim_latest_version(cask_info)
      lines = cask_info.split(/\n/)
      lines[0]&.gsub(/.+: (.+)/, '\1')
    end
  end
end
