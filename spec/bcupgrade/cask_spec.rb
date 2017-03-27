require 'spec_helper'

describe Bcupgrade::Cask do
  let(:instance) { described_class.new }

  describe '#load_config' do
    context 'if the config file exists' do
      it 'returns a object' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:load_config)).to eq('ignore' => %w(atom omniplan1))
      end
    end

    context 'if the config file does not exist' do
      it 'returns a nil' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:load_config)).to eq(nil)
      end
    end
  end

  describe '#ignore_casks' do
    let(:casks) { %w(1password alfred atom bartender) }

    it 'has a kind of Array' do
      expect(instance.send(:ignore_casks, casks)).to be_kind_of(Array)
    end

    context "if config['ignore'] exists" do
      it 'returns an argument "casks" without ignore values' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:ignore_casks, casks)).to eq(%w(1password alfred bartender))
      end
    end

    context "if config['ignore'] does not exist" do
      it 'returns an argument "casks"' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:ignore_casks, casks)).to eq(%w(1password alfred atom bartender))
      end
    end
  end

  describe '#check_list' do
    let(:output) { "atom (!)\n1password\nactprinter\nalfred\n" }

    before do
      allow(Bcupgrade::BrewCask).to receive(:list).and_return(output)
    end

    it 'has a kind of Array' do
      expect(instance.send(:check_list)).to be_kind_of(Array)
    end

    it 'returns "installed_casks" and "error_casks"' do
      expect(instance.send(:check_list)).to eq([%w(1password actprinter alfred), %w(atom)])
    end

    it 'has not include "(!)"' do
      expect(instance.send(:check_list).to_s).not_to include('(!)')
    end
  end
end
