require 'spec_helper'

describe Bcupgrade do
  describe '#load_config' do
    context 'if the config file exists' do
      it 'returns a object' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(described_class.load_config).to eq('ignore' => %w(atom omniplan1))
      end
    end

    context 'if the config file does not exist' do
      it 'returns a nil' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(described_class.load_config).to eq(nil)
      end
    end
  end

  describe '#installed_casks' do
    let(:casks) { %w(1password alfred atom bartender) }
    let(:config) { { 'ignore' => %w(atom omniplan1) } }

    it 'has a kind of Array' do
      expect(described_class.installed_casks(casks, config)).to be_kind_of(Array)
    end

    context "if config['ignore'] exists" do
      it 'returns an argument "casks" without ignore values' do
        expect(described_class.installed_casks(casks, config)).to eq(%w(1password alfred bartender))
      end
    end

    context "if config['ignore'] does not exist" do
      it 'returns an argument "casks"' do
        config = { 'foo' => %w(bar buzz) }
        expect(described_class.installed_casks(casks, config)).to eq(%w(1password alfred atom bartender))
      end
    end
  end

  describe '#check_list' do
    before do
      output = "atom (!)\n1password\nactprinter\nalfred\n"
      allow(described_class).to receive(:brew_cask_list).and_return(output)
    end

    it 'has a kind of Array' do
      expect(described_class.check_list).to be_kind_of(Array)
    end

    it 'returns "installed_casks" and "error_casks"' do
      expect(described_class.check_list).to eq([%w(1password actprinter alfred), %w(atom)])
    end

    it 'has not include "(!)"' do
      expect(described_class.check_list.to_s).not_to include('(!)')
    end
  end

  describe '#check_version' do
    context 'When raise error "Error: File /Users/***/*** is not a plain file"' do
      it 'returns "error"' do
        brew_cask_info_error = ''
        allow(described_class).to receive(:brew_cask_info).and_return(brew_cask_info_error)
        expect(described_class.check_version('dropbox')).to eq('error')
      end
    end

    context 'When the latest version is installed,' do
      it 'returns "nil"' do
        output = File.read('spec/factories/brew_cask_info_atom.txt')
        allow(described_class).to receive(:brew_cask_info).and_return(output)
        expect(described_class.check_version('atom')).to eq(nil)
      end
    end

    context 'When the latest version is not installed,' do
      it 'returns "version" string' do
        output = File.read('spec/factories/brew_cask_info_android-studio.txt')
        allow(described_class).to receive(:brew_cask_info).and_return(output)
        expect(described_class.check_version('android-studio')).to be_kind_of(String)
      end
    end

    context 'When the previous version is installed,' do
      example '(6.3.1) returns "6.3.2"' do
        output = File.read('spec/factories/brew_cask_info_1password.txt')
        allow(described_class).to receive(:brew_cask_info).and_return(output)
        expect(described_class.check_version('atom')).to eq('6.3.2')
      end

      example '(2.1.2.0,143.2915827) returns "2.1.3.0,143.3101438"' do
        output = File.read('spec/factories/brew_cask_info_android-studio.txt')
        allow(described_class).to receive(:brew_cask_info).and_return(output)
        expect(described_class.check_version('android-studio')).to eq('2.1.3.0,143.3101438')
      end

      example '(3.0.3_694) returns "3.1_718"' do
        output = File.read('spec/factories/brew_cask_info_alfred.txt')
        allow(described_class).to receive(:brew_cask_info).and_return(output)
        expect(described_class.check_version('alfred')).to eq('3.1_718')
      end

      example '(latest) returns "nil"' do
        output = File.read('spec/factories/brew_cask_info_betterzipql.txt')
        allow(described_class).to receive(:brew_cask_info).and_return(output)
        expect(described_class.check_version('betterzipql')).to eq(nil)
      end
    end
  end
end
