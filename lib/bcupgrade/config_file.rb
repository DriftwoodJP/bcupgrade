# frozen_string_literal: true

require 'yaml'

module Bcupgrade
  class ConfigFile
    def initialize
      @file = File.join(ENV['HOME'], '.bcupgrade')
    end

    def load
      load_config
    end

    def ignore
      Array(load['ignore'])
    end

    private

    def load_config
      if File.exist?(@file)
        YAML.load_file(@file)
      else
        ''
      end
    end
  end
end
