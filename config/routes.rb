# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :categories

  resources :discussions do
    resources :posts, module: :discussions

    collection do
      get 'category/:id', to: 'categories/discussions#index', as: :category
    end
  end

  root to: 'main#index'
end
