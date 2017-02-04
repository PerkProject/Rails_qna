require 'rails_helper'

RSpec.shared_examples 'votable' do
  votable_klass_symbol = described_class.to_s.underscore.to_sym

  it { is_expected.to have_many(:votes).dependent(:destroy) }

  let!(:votable) { create(votable_klass_symbol) }

  describe '#show rating' do
    before do
      create_list("positive_vote_for_#{votable_klass_symbol}", 3, votable: votable)
      create_list("negative_vote_for_#{votable_klass_symbol}", 1, votable: votable)
    end

    it 'does equal 2' do
      expect(votable.rating).to eq(2)
    end
  end
end
