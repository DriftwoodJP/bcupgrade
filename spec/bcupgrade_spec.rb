require 'spec_helper'

describe Bcupgrade do
  it 'has a version number' do
    expect(Bcupgrade::VERSION).not_to be nil
  end

  describe '#brew_cask_info' do
    let(:installed_path) { Bcupgrade::CASKROOM_PATH }
    let(:app_name) { 'atom' }
    let(:cask_info) { Bcupgrade::brew_cask_info(app_name) }
    let(:first_line) {
      lines = cask_info.split(/\n/)
      lines[0]
    }
    let(:latest_version) { first_line.gsub(/.+: (.+)/, '\1') }

    it 'has a app name of cask' do
      expect(first_line).to match(/#{app_name}: /)
    end

    it 'has a latest version number of cask' do
      expect(first_line).to match(latest_version)
    end

    it 'has installed paths of cask' do
      expect(cask_info).to include("#{installed_path}/#{app_name}/")
    end
  end

  describe '#brew_cask_list' do
    let(:cask_list) { Bcupgrade::brew_cask_list }

    it 'should be a kind of String' do
      expect(cask_list).to be_kind_of(String)
    end
  end

  describe '#check_list' do
    before do
      allow(Bcupgrade).to receive(:brew_cask_list).and_return("atom (!)\n1password\nactprinter\nalfred\n")
    end

    it 'should be a kind of Array' do
      expect(Bcupgrade.check_list).to be_kind_of(Array)
    end

    it 'should not include "(!)"' do
      expect(Bcupgrade.check_list.to_s).not_to include('(!)')
    end
  end

  describe '#check_version' do
    it 'returns Array' do
      expect(Bcupgrade.check_version(['1password'])).to be_kind_of(Array)
    end
  end

  describe '#upgrade' do

  end
end
