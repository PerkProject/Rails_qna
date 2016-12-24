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
  has_many :authorizations , dependent: :destroy

  def check_owner(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    return nil if auth.empty? || !auth.try(:dig, :info, :email)
    authorization = Authorization.find_or_initialize_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization.persisted?

    email = auth.info[:email]
    user = User.find_by(email: email) if email
    return if email.nil?
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end
end
