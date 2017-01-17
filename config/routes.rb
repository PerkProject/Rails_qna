# frozen_string_literal: true
Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "questions#index"
  resources :users, only: [] do
    collection do
      post 'require_email_for_auth'
    end
  end

  concern :votable do
    member do
      post 'voteup'
      post 'votedown'
      delete 'votedel'
    end
  end
  concern :commentable do
    resources :comments, only: [:new, :create, :destroy], shallow: true
  end
  resources :questions, except: :edit, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], only: [:create, :update, :destroy, :edit], shallow: true do
      patch :answer_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  mount ActionCable.server => '/cable'

  get 'terms' => 'pages#terms'
  get 'policy' => 'pages#policy'

  namespace :api do
    namespace :v1 do
      resource :profiles  do
        get :me, on: :collection
        get :list, on: :collection
      end
      resources :questions, only: [:index, :show, :create], shallow: true do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end
end
