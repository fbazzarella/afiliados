require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  it { should have_many(:campaigns).dependent(:nullify) }

  describe '#body_for' do
    pending
  end

  describe 'private methods' do
    describe '#replace_links' do
      pending
    end

    describe '#append_footer' do
      pending
    end

    describe '#set_domain_and_return' do
      pending
    end

    describe '#parse_document' do
      pending
    end

    describe '#parse_fragment' do
      pending
    end

    describe '#load_footer' do
      pending
    end
  end
end
