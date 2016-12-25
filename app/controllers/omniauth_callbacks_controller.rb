class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth

  def facebook
    process_authorization('Facebook')
  end

  def twitter
    process_authorization('Twitter')
  end

  private

  def set_auth
    @auth = request.env['omniauth.auth']
  end

  def process_authorization(provider)
    @user = User.find_for_oauth(@auth)
    if @user.email.blank?
      session['devise.omiauth.auth'] = {
        provider: @auth.provider,
        uid: @auth.uid.to_i,
        user_password: @user.password
      }
      render template: 'devise/registrations/email_required'
    elsif @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
