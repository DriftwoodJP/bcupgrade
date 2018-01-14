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

    def ignore
      load['ignore'].map { |e| e ? e : '' }
    rescue StandardError
      ['']
    end
  end
end
