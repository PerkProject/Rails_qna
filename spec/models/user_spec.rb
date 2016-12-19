require 'rails_helper'

RSpec.describe User do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it { should have_many :answers }
  it { should have_many :questions }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user) }

  context 'Validate authority of question' do
    it 'is author' do
      expect(user.check_owner(question)).to be true
    end

    it 'is not author' do
      not_author = create(:user)
      expect(not_author.check_owner(question)).to be false
    end
  end
end