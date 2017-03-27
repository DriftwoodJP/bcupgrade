require 'yaml'

module Bcupgrade
  class Cask
    attr_reader :config, :list

    def initialize
      @config = load_config
      @list = check_list
    end

    private

    def check_list
      cask_list = BrewCask.list.split(/\n/)

      installed_casks = []
      error_casks = []
      cask_list.each do |cask|
        if cask.include?(' (!)')
          error_casks.push(cask.delete(' (!)'))
        else
          installed_casks.push(cask)
        end
      end

      [ignore_casks(installed_casks), error_casks]
    end

    def load_config
      file = File.join(ENV['HOME'], '.bcupgrade')
      YAML.load_file(file) if File.exist?(file)
    end

    def ignore_casks(casks)
      if config.nil?
        casks
      else
        casks - Array(config['ignore'])
      end
    end
  end
end
