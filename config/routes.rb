# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "questions#index"

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
end
