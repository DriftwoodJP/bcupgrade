# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe Bcupgrade::ConfigFile do
  let(:instance) { described_class.new }

  describe '#load_config' do
    context 'when the config file exists' do
      it 'returns a object' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:load_config)).to eq('ignore' => %w[atom omniplan1])
      end
    end

    context 'when the config file does not exist' do
      it 'returns a empty' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:load_config)).to be_empty
      end
    end
  end

  describe '#list_ignore' do
    context 'when the config file exists' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns ignore casks Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('spec/factories')
        expect(instance.send(:ignore)).to eq(%w[atom omniplan1])
      end
    end

    context 'when the config file does not exist' do
      it 'returns a Array' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:ignore)).to be_kind_of(Array)
      end

      it 'returns a empty' do
        allow(ENV).to receive(:[]).with('HOME').and_return('')
        expect(instance.send(:ignore)).to be_empty
      end
    end
  end
end
