# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations

  def check_owner(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    return unless auth.is_a?(Hash) && OmniAuth::AuthHash.new(auth).valid?

    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.create_authorization(auth)
    end

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
