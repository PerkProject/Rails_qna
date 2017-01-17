require 'rails_helper'

RSpec.describe User do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many :answers }
  it { is_expected.to have_many :questions }
  it { is_expected.to have_many(:votes) }
  it { is_expected.to have_many(:comments) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

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
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: "name@mail-123456-facebook.com" }) }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists in db by email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
        end

        it 'creates authorization for user' do
          expect { described_class.build_by_omniauth_params(user.email, auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with right provider and uid' do
          user = described_class.find_for_oauth(auth)
          user = described_class.build_by_omniauth_params(user.email, auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(described_class.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: "name@mail-123456-facebook.com" }) }

      it 'not creates new user' do
        expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(0)
        expect { described_class.build_by_omniauth_params(user.email, auth) }.to change(described_class, :count).by(0)
      end

      it 'returns new user' do
        expect(described_class.find_for_oauth(auth)).to be_a(described_class)
        expect(described_class.build_by_omniauth_params(user.email, auth)).to be_a(described_class)
      end

      it 'fills user email' do
        user = described_class.find_for_oauth(auth)
        expect(user.email).to eq ''
      end
      it 'creates authorization for user' do
        user = described_class.find_for_oauth(auth)
        expect(user.authorizations).not_to be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = described_class.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
