# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'main#index'

  resources :discussions
end
