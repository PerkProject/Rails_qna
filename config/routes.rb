# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      post 'voteup'
      post 'votedown'
      delete 'votedel'
    end
  end
  concern :commentable do
    resources :comments, only: [:create]
  end
  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :answer_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  mount ActionCable.server => '/cable'
end
