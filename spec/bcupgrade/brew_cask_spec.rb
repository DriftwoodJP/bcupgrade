# frozen_string_literal: true
require 'spec_helper'

describe Bcupgrade::BrewCask do
  describe '#list' do
    let(:cask_list) { described_class.list }

    it 'has a kind of String' do
      expect(cask_list).to be_kind_of(String)
    end
  end

  describe '#info' do
    let(:app_name) { 'atom' }
    let(:cask_info) { described_class.info(app_name) }
    let(:first_line) do
      lines = cask_info.split(/\n/)
      lines[0]
    end
    let(:latest_version) { first_line.gsub(/.+: (.+)/, '\1') }

    it 'has a app name of cask' do
      expect(first_line).to match(/#{app_name}: /)
    end

    it 'has a latest version number of cask' do
      expect(first_line).to match(latest_version)
    end

    it 'has installed paths of cask version number' do
      expect(cask_info).to include("/#{app_name}/#{latest_version}")
    end
  end
end
