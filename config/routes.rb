# frozen_string_literal: true

Rails.application.routes.draw do
  get 'greetings/hello'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post 'auth/register', to: 'users#register'
  post 'auth/login', to: 'users#login'
  get 'test', to: 'users#test'
end
