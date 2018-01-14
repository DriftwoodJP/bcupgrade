# frozen_string_literal: true

require 'spec_helper'
require 'readline'

describe Bcupgrade::Cask do
  let(:options) { {} }
  let(:args) { [] }
  let(:config) { Bcupgrade::ConfigFile.new }
  let(:instance) { described_class.new(options, args, config) }

  describe 'Private Method' do
    describe '#exclude_ignore_casks' do
      let(:casks) { %w[1password alfred atom bartender] }

      context 'when argument "casks" is exist' do
        it 'has a kind of Array' do
          expect(instance.send(:exclude_ignore_casks, casks)).to be_kind_of(Array)
        end
      end

      context 'when argument "casks" is not exist' do
        it 'has a kind of Array' do
          expect(instance.send(:exclude_ignore_casks, [''])).to be_kind_of(Array)
        end
      end

      context "when config['ignore'] exists" do
        it 'returns the array "casks" without ignore values' do
          allow(config).to receive(:ignore).and_return(%w[atom omniplan1])
          expect(instance.send(:exclude_ignore_casks, casks)).to eq(%w[1password alfred bartender])
        end
      end

      context "when config['ignore'] does not exist" do
        it 'returns the argument "casks"' do
          allow(config).to receive(:ignore).and_return([''])
          expect(instance.send(:exclude_ignore_casks, casks)).to eq(%w[1password alfred atom bartender])
        end
      end
    end

    describe '#upgrade_target' do
      let(:output) { "atom\n1password\nactprinter\nalfred\n" }

      it 'has a kind of Array' do
        expect(instance.send(:upgrade_target)).to be_kind_of(Array)
      end

      context 'when the @args does not exist' do
        before do
          allow(Bcupgrade::BrewCask).to receive(:outdated).and_return(output)
        end

        it 'returns outdated casks' do
          expect(instance.send(:upgrade_target)).to eq(%w[atom 1password actprinter alfred])
        end
      end

      context 'when the @args exists' do
        let(:args) { %w[cask1 cask2] }

        it 'has the @args' do
          expect(instance.send(:upgrade_target)).to eq(args)
        end
      end
    end

    describe '#prompt_answer_yes' do
      let(:casks) { %w[1password alfred atom bartender] }

      context 'when options[:install] is true ("-y")' do
        it 'returns a true' do
          instance.instance_variable_set('@options', install: true)
          expect(instance.send(:prompt_answer_yes?, casks)).to be_truthy
        end
      end

      context 'when input "y" to the prompt' do
        it 'returns a true' do
          instance.instance_variable_set('@options', install: false)
          allow(Readline).to receive(:readline).and_return('y')
          expect(instance.send(:prompt_answer_yes?, casks)).to be_truthy
        end
      end

      context 'when input "n" to the prompt' do
        it 'returns a false' do
          instance.instance_variable_set('@options', install: false)
          allow(Readline).to receive(:readline).and_return('n')
          expect(instance.send(:prompt_answer_yes?, casks)).to be_falsey
        end
      end

      context 'when input "yes" to the prompt' do
        it 'returns a true' do
          instance.instance_variable_set('@options', install: false)
          allow(Readline).to receive(:readline).and_return('yes')
          expect(instance.send(:prompt_answer_yes?, casks)).to be_truthy
        end
      end
    end
  end

  describe '#upgrade_version' do
    let(:casks) { ['sublime-text2'] }

    before do
      allow(Bcupgrade::BrewCask).to receive(:install).and_return('Success install')
    end

    context 'when options[:dry_run] is true ("-d")' do
      it 'returns a nil' do
        instance.instance_variable_set('@options', dry_run: true)
        expect(instance.send(:upgrade_version, casks)).to eq(nil)
      end
    end
  end

  describe '#list_ignore' do
    context 'when @config.ignore has some elements of an array' do
      it 'has a kind of String' do
        allow(config).to receive(:ignore).and_return(%w[iterm2 omniplan1 sketch])
        expect(instance.send(:list_ignore)).to be_kind_of(String)
      end

      it 'returns ignore cask names' do
        allow(config).to receive(:ignore).and_return(%w[iterm2 omniplan1 sketch])
        expect(instance.send(:list_ignore)).to eq('iterm2 omniplan1 sketch')
      end
    end

    context 'when @config.ignore has no element of an array' do
      it 'has a kind of String' do
        allow(config).to receive(:ignore).and_return(%w[])
        expect(instance.send(:list_ignore)).to be_kind_of(String)
      end

      it 'returns a ""' do
        allow(config).to receive(:ignore).and_return(%w[])
        expect(instance.send(:list_ignore)).to eq('')
      end
    end
  end
end
