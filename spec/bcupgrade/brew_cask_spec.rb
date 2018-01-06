# frozen_string_literal: true

require 'spec_helper'

describe Bcupgrade::BrewCask do
  describe '.#outdated' do
    let(:outdated) { File.read('spec/factories/brew_cask_outdated_quiet.txt') }

    it 'has a cask name' do
      expect(outdated).to include('omnioutliner')
    end

    it 'has not a cask version' do
      expect(outdated).not_to match(/[0-9]\.[0-9]/)
    end
  end
end
