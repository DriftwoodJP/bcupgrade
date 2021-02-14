# frozen_string_literal: true

require 'yaml'

module Bcupgrade
  class ConfigFile
    def initialize
      @file = File.join(ENV['HOME'], '.bcupgrade')
    end

    def load
      if File.exist?(@file)
        YAML.load_file(@file)
      else
        { 'ignore' => [''] }
      end
    end

    def ignored_casks
      load['ignore'].map { |e| e || '' }
    rescue StandardError
      ['']
    end

    def list_ignored_casks
      ignored_casks.join(' ')
    end
  end
end
