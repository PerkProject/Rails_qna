class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user

  def facebook
    process_authorization('Facebook')
  end

  def twitter
    process_authorization('Twitter')
  end

  private

  def find_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def process_authorization(provider)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      set_flash_message(:alert, :failure, kind: provider, reason: 'wrong auth') if is_navigational_format?
      redirect_to new_user_registration_path
    end
  end
end