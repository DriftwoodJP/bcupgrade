require 'yaml'

module Bcupgrade
  class Cask
    attr_reader :list

    def initialize(options, args)
      @config = config
      @options = options
      @args = args.uniq
      @list = upgrade_target
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
  end
end
