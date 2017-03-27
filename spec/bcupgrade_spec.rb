require 'spec_helper'

describe Bcupgrade do
  describe '#check_version' do
    context 'When raise error "Error: File /Users/***/*** is not a plain file"' do
      it 'returns "error"' do
        brew_cask_info_error = ''
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(brew_cask_info_error)
        expect(described_class.check_version('dropbox')).to eq('error')
      end
    end

    context 'When the latest version is installed,' do
      it 'returns "nil"' do
        output = File.read('spec/factories/brew_cask_info_atom.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(described_class.check_version('atom')).to eq(nil)
      end
    end

    context 'When the latest version is not installed,' do
      it 'returns "version" string' do
        output = File.read('spec/factories/brew_cask_info_android-studio.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(described_class.check_version('android-studio')).to be_kind_of(String)
      end
    end

    context 'When the previous version is installed,' do
      example '(6.3.1) returns "6.3.2"' do
        output = File.read('spec/factories/brew_cask_info_1password.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(described_class.check_version('atom')).to eq('6.3.2')
      end

      example '(2.1.2.0,143.2915827) returns "2.1.3.0,143.3101438"' do
        output = File.read('spec/factories/brew_cask_info_android-studio.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(described_class.check_version('android-studio')).to eq('2.1.3.0,143.3101438')
      end

      example '(3.0.3_694) returns "3.1_718"' do
        output = File.read('spec/factories/brew_cask_info_alfred.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(described_class.check_version('alfred')).to eq('3.1_718')
      end

      example '(latest) returns "nil"' do
        output = File.read('spec/factories/brew_cask_info_betterzipql.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(described_class.check_version('betterzipql')).to eq(nil)
      end
    end
  end
end
