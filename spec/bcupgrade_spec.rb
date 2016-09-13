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
    context 'When the latest version is installed,' do
      it 'should return "nil"' do
        allow(Bcupgrade).to receive(:brew_cask_info).and_return( File.read("#{Dir.pwd}/spec/factories/brew_cask_info_atom.txt") )
        expect(Bcupgrade.check_version('atom')).to eq(nil)
      end
    end

    context 'When the latest version is not installed,' do
      it 'should return "version" string' do
        allow(Bcupgrade).to receive(:brew_cask_info).and_return( File.read("#{Dir.pwd}/spec/factories/brew_cask_info_android-studio.txt") )
        expect(Bcupgrade.check_version('android-studio')).to be_kind_of(String)
      end
    end

    context 'When the previous version is installed,' do
      example '(6.3.1) should return "6.3.2"' do
        allow(Bcupgrade).to receive(:brew_cask_info).and_return( File.read("#{Dir.pwd}/spec/factories/brew_cask_info_1password.txt") )
        expect(Bcupgrade.check_version('atom')).to eq('6.3.2')
      end

      example '(2.1.2.0,143.2915827) should return "2.1.3.0,143.3101438"' do
        allow(Bcupgrade).to receive(:brew_cask_info).and_return( File.read("#{Dir.pwd}/spec/factories/brew_cask_info_android-studio.txt") )
        expect(Bcupgrade.check_version('android-studio')).to eq('2.1.3.0,143.3101438')
      end

      example '(3.0.3_694) should return "3.1_718"' do
        allow(Bcupgrade).to receive(:brew_cask_info).and_return( File.read("#{Dir.pwd}/spec/factories/brew_cask_info_alfred.txt") )
        expect(Bcupgrade.check_version('alfred')).to eq('3.1_718')
      end

      example '(latest) should return "nil"' do
        allow(Bcupgrade).to receive(:brew_cask_info).and_return( File.read("#{Dir.pwd}/spec/factories/brew_cask_info_betterzipql.txt") )
        expect(Bcupgrade.check_version('betterzipql')).to eq(nil)
      end
    end
  end

  describe '#upgrade' do

  end
end
