# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :categories

  resources :discussions do
    resources :posts, only: [:create, :show, :edit, :update], module: :discussions
  end

  root to: 'main#index'
end
