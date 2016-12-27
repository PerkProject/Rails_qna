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


    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }


  end
end