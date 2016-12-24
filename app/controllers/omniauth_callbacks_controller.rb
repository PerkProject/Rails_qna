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
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?

    else
      set_flash_message(:alert, :failure, kind: provider, reason: 'wrong auth') if is_navigational_format?
      redirect_to new_user_registration_path and return
    end
  end

end
