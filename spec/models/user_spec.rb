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

  describe '.find_for_oauth and .build_by_omniauth_params' do
    let!(:user){ create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: "name@mail-123456-facebook.com" }) }

   context 'user already has authorization' do
     it 'returns the user' do
       user.authorizations.create(provider: 'facebook', uid: '123456')
       expect(User.find_for_oauth(auth)).to eq user
         end
     end

    context 'user has no authorization' do

      context 'user already exists in db by email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email })}

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.not_to change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.build_by_omniauth_params(user.email, auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with right provider and uid' do
          user = User.find_for_oauth(auth)
          user = User.build_by_omniauth_params(user.email, auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: "name@mail-123456-facebook.com" })}

      it 'not creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(0)
        expect { User.build_by_omniauth_params(user.email, auth) }.to change(User, :count).by(0)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
        expect(User.build_by_omniauth_params(user.email, auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq ''
      end
      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
 end
end