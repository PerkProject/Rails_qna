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

  resources :questions do

    concerns :votable

    resources :answers, shallow: true do
      patch :answer_best, on: :member
      concerns :votable
    end
  end

  resources :attachments, only: [:destroy]
end
