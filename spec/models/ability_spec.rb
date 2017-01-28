require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'when user guest' do
    let(:user) { nil }
    it { is_expected.to be_able_to :read, :all }
    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.not_to be_able_to :read, User }
  end

  context 'when user authorized' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }

    it { is_expected.to be_able_to :read, :all }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }
    it { is_expected.to be_able_to :create, Attachment }
    it { is_expected.to be_able_to :create, Subscription }

    it { is_expected.to be_able_to :make_best, create(:answer, question: question) }
    it { is_expected.not_to be_able_to :make_best, create(:answer, question: other_question) }

    it { is_expected.to be_able_to :destroy, create(:question, user: user) }
    it { is_expected.to be_able_to :destroy, create(:answer, user: user) }
    it { is_expected.to be_able_to :destroy, create(:attachment, attachable: question) }
    it { is_expected.to be_able_to :destroy, create(:comment, user: user) }
    it { is_expected.not_to be_able_to :destroy, create(:question, user: other_user) }
    it { is_expected.not_to be_able_to :destroy, create(:answer, user: other_user) }
    it { is_expected.not_to be_able_to :destroy, create(:attachment, attachable: other_question) }
    it { is_expected.not_to be_able_to :destroy, create(:comment, user: other_user) }
    it { is_expected.to be_able_to :destroy, create(:subscription, user: user) }

    it { is_expected.to be_able_to :update, create(:question, user: user) }
    it { is_expected.to be_able_to :update, create(:answer, user: user) }
    it { is_expected.not_to be_able_to :update, create(:question, user: other_user) }
    it { is_expected.not_to be_able_to :update, create(:answer, user: other_user) }

    it { is_expected.to be_able_to :vote, create(:question, user: other_user) }
    it { is_expected.to be_able_to :vote, create(:answer, user: other_user) }
    it { is_expected.not_to be_able_to :vote, create(:question, user: user) }
    it { is_expected.not_to be_able_to :vote, create(:answer, user: user) }

    it { is_expected.to be_able_to :answer_best, create(:answer, question: question, user: user) }
    it { is_expected.not_to be_able_to :answer_best, other_user }

    it { is_expected.to be_able_to :me, User }
    it { is_expected.to be_able_to :list, User }
  end
end
