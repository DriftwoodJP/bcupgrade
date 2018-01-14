# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe Bcupgrade::ConfigFile do
  let(:instance) { described_class.new }

  describe '#load' do
    context 'when the config file exists' do
      it 'returns ignore elements from ~/.bcupgrade' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:load)).to eq('ignore' => %w[atom omniplan1])
      end
    end

    context 'when the config file does not exist' do
      it 'returns a "" element' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:load)).to eq('ignore' => [''])
      end
    end
  end

  describe '#ignore' do
    context 'when the config file exists' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns ignore elements' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:ignore)).to eq(%w[atom omniplan1])
      end
    end

    context 'when the config file does not exist' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns a "" element' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:ignore)).to eq([''])
      end
    end

    context 'when the config file is empty' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories/empty')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns a "" element' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories/empty')
        expect(instance.send(:ignore)).to eq([''])
      end
    end

    context 'when the ignore has no element in the config file' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories/empty_value')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns a "" element' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories/empty_value')
        expect(instance.send(:ignore)).to eq([''])
      end
    end

    context 'when the ignore has nil element in the config file' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories/empty_value_nil')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns a "" element' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories/empty_value_nil')
        expect(instance.send(:ignore)).to eq([''])
      end
    end
  end
end
