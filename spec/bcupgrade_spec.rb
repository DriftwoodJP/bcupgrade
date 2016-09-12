require 'spec_helper'

describe Bcupgrade do
  it 'has a version number' do
    expect(Bcupgrade::VERSION).not_to be nil
  end

  describe 'brew cask info' do
    let(:app_name) { 'atom' }
    let(:cask_info) { `brew cask info #{app_name}` }
    let(:first_line) {
      lines = cask_info.split(/\n/)
      lines[0]
    }
    let(:version) { first_line.gsub(/.+: (.+)/, '\1') }

    it 'has a app name' do
      expect(first_line).to match(/#{app_name}: /)
    end

    it 'has a version number' do
      expect(first_line).to match(version)
    end

    it 'has install paths' do
      expect(cask_info).to include("/usr/local/Caskroom/#{app_name}/")
    end
  end

  # describe '#check_update' do
  #   it 'returns Array' do
  #     expect(Bcupgrade.check_update(['atom'])).to eq(['atom'])
  #   end
  # end
end
