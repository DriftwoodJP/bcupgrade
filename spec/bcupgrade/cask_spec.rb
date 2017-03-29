require 'spec_helper'

describe Bcupgrade::Cask do
  let(:options) { {} }
  let(:args) { [] }
  let(:instance) { described_class.new(options, args) }

  describe 'Private Method' do
    describe '#load_config' do
      context 'if the config file exists' do
        it 'returns a object' do
          allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
          expect(instance.send(:config)).to eq('ignore' => %w(atom omniplan1))
        end
      end

      context 'if the config file does not exist' do
        it 'returns a nil' do
          allow(ENV).to receive(:[]).with('HOME').and_return('')
          expect(instance.send(:config)).to eq(nil)
        end
      end
    end

    describe '#ignore_casks' do
      let(:casks) { %w(1password alfred atom bartender) }

      it 'has a kind of Array' do
        expect(instance.send(:trim_ignore_casks, casks)).to be_kind_of(Array)
      end

      context "if config['ignore'] exists" do
        it 'returns an argument "casks" without ignore values' do
          allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
          expect(instance.send(:trim_ignore_casks, casks)).to eq(%w(1password alfred bartender))
        end
      end

      context "if config['ignore'] does not exist" do
        it 'returns an argument "casks"' do
          allow(ENV).to receive(:[]).with('HOME').and_return('')
          expect(instance.send(:trim_ignore_casks, casks)).to eq(%w(1password alfred atom bartender))
        end
      end
    end

    describe '#create_upgrade_target' do
      let(:output) { "atom (!)\n1password\nactprinter\nalfred\n" }

      it 'has a kind of Array' do
        expect(instance.send(:upgrade_target)).to be_kind_of(Array)
      end

      context 'if the @args does not exist' do
        before do
          allow(Bcupgrade::BrewCask).to receive(:list).and_return(output)
        end

        it 'returns "installed_casks" and "error_casks"' do
          expect(instance.send(:upgrade_target)).to eq([%w(1password actprinter alfred), %w(atom)])
        end

        it 'has not include "(!)"' do
          expect(instance.send(:upgrade_target).to_s).not_to include('(!)')
        end
      end

      context 'if the @args exists' do
        let(:args) { %w(cask1 cask2) }

        it 'has @args' do
          expect(instance.send(:upgrade_target)).to eq([%w(cask1 cask2), %w()])
        end
      end
    end

    describe '#trim_target_to_a' do
      let(:array) { ['atom (!)', '1password', 'actprinter', 'alfred'] }

      it 'returns "installed_casks" and "error_casks"' do
        expect(instance.send(:trim_target_to_a, array)).to eq([%w(1password actprinter alfred), %w(atom)])
      end
    end

    describe '#trim_latest_version' do
      context 'if the brew cask info does not exist(raise Error)' do
        it 'returns the nil' do
          input = ''
          expect(instance.send(:trim_latest_version, input)).to eq(nil)
        end
      end

      context 'if the brew cask info exists' do
        it 'returns a version number' do
          input = File.read('spec/factories/brew_cask_info_atom.txt')
          expect(instance.send(:trim_latest_version, input)).to eq('1.10.2')
        end

        it 'returns a "6.3.2" format' do
          input = File.read('spec/factories/brew_cask_info_1password.txt')
          expect(instance.send(:trim_latest_version, input)).to eq('6.3.2')
        end

        it 'returns a "2.1.3.0,143.3101438" format' do
          input = File.read('spec/factories/brew_cask_info_android-studio.txt')
          expect(instance.send(:trim_latest_version, input)).to eq('2.1.3.0,143.3101438')
        end

        it 'returns a "3.1_718" format' do
          input = File.read('spec/factories/brew_cask_info_alfred.txt')
          expect(instance.send(:trim_latest_version, input)).to eq('3.1_718')
        end

        it 'returns a "latest" format' do
          input = File.read('spec/factories/brew_cask_info_betterzipql.txt')
          expect(instance.send(:trim_latest_version, input)).to eq('latest')
        end
      end
    end
  end

  describe '#check_version' do
    it 'returns a Array' do
      instance.instance_variable_set('@list', [%w(android-studio), %w()])
      output = File.read('spec/factories/brew_cask_info_android-studio.txt')
      allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
      expect(instance.send(:check_version)).to be_kind_of(Array)
    end

    context 'When brew cask info raise error "Error: No available Cask for foobar"' do
      it 'returns  an empty array' do
        instance.instance_variable_set('@list', [%w(foobar), %w()])
        expect(instance.send(:check_version)).to eq([])
      end

      it 'returns an empty array (using stub)' do
        instance.instance_variable_set('@list', [%w(foobar), %w()])
        allow(Bcupgrade::BrewCask).to receive(:info).and_return('')
        expect(instance.send(:check_version)).to eq([])
      end
    end

    context 'When the latest version is installed,' do
      it 'returns an empty array' do
        instance.instance_variable_set('@list', [%w(atom), %w()])
        output = File.read('spec/factories/brew_cask_info_atom.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(instance.send(:check_version)).to eq([])
      end
    end

    context 'When the latest version is not installed,' do
      it 'returns an array that include cask name' do
        instance.instance_variable_set('@list', [%w(android-studio), %w()])
        output = File.read('spec/factories/brew_cask_info_android-studio.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(instance.send(:check_version)).to eq(['android-studio'])
      end
    end

    context 'When the previous version is installed,' do
      it 'returns an array that include cask name' do
        instance.instance_variable_set('@list', [%w(1password), %w()])
        output = File.read('spec/factories/brew_cask_info_1password.txt')
        allow(Bcupgrade::BrewCask).to receive(:info).and_return(output)
        expect(instance.send(:check_version)).to eq(['1password'])
      end
    end
  end

  xdescribe '#upgrade' do
  end
end
