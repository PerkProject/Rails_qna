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

        it 'assigns user email to blank' do
          expect(assigns(:user).email).to eq("")
        end

        it 'redirects to email_request' do
          expect(response).to render_template('devise/registrations/email_required')
        end
      end

    end
  end
end