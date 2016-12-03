# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, shallow: true do
      patch :answer_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
end
