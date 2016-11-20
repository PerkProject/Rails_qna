require 'rails_helper'

RSpec.describe User do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it { should have_many :answers }
  it { should have_many :questions }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user) }

  context 'Validate authority of question' do
    it 'is author' do
      expect(user.check_user(question)).to be true
    end

    it 'is not author' do
      not_author = create(:user)
      expect(not_author.check_user(question)).to be false
    end
  end
end