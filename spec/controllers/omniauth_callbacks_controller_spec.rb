require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  ['Facebook', 'Twitter'].each do |provider|
    describe "GET ##{provider.downcase.to_sym}" do
      context 'if auth valid' do
        before do
          @request.env["omniauth.auth"] = mock_auth_hash(provider)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          get :facebook
        end

        it 'assigns user' do
          expect(assigns(:user).email).to eq("name@mail-12345-#{provider.downcase}.com")
        end

        it 'sets flash message' do
          expect(controller).to set_flash[:notice]
        end

        it 'redirects to root' do
          expect(response).to redirect_to root_path
        end
      end

      context 'if auth is invalid' do
        before do
          @request.env["omniauth.auth"] = invalid_mock_auth_hash(provider)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          get :facebook
        end

        it 'redirects to registrations path' do
          expect(response).to redirect_to new_user_registration_path
        end

        it 'sets flash message' do
          expect(controller).to set_flash[:alert]
        end
      end
    end
  end
end