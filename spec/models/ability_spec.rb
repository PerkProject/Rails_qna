require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'when user guest' do
    let(:user) { nil }
    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  context 'when user authorized' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    it { should be_able_to :accept, create(:answer, question: question) }
    it { should_not be_able_to :accept, create(:answer, question: other_question) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should be_able_to :destroy, create(:attachment, attachable: question) }
    it { should be_able_to :destroy, create(:comment, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other_user) }
    it { should_not be_able_to :destroy, create(:answer, user: other_user) }
    it { should_not be_able_to :destroy, create(:attachment, attachable: other_question) }
    it { should_not be_able_to :destroy, create(:comment, user: other_user) }

    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }

    it { should be_able_to :voteup, create(:question, user: other_user) }
    it { should be_able_to :voteup, create(:answer, user: other_user) }
    it { should_not be_able_to :voteup, create(:question, user: user) }
    it { should_not be_able_to :voteup, create(:answer, user: user) }

    it { should be_able_to :votedown, create(:question, user: other_user) }
    it { should be_able_to :votedown, create(:answer, user: other_user) }
    it { should_not be_able_to :votedown, create(:question, user: user) }
    it { should_not be_able_to :votedown, create(:answer, user: user) }

    it { should be_able_to :votedel, create(:question, user: other_user, votes: create_list(:vote, 1, user: user)) }
    it { should be_able_to :votedel, create(:answer, user: other_user, votes: create_list(:vote, 1, user: user)) }
    it { should_not be_able_to :votedel, create(:question, user: user) }
    it { should_not be_able_to :votedel, create(:answer, user: user) }

  end
end