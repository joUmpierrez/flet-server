# frozen_string_literal: true

Rails.application.routes.draw do
  get 'orders/ordersPerHour', to: 'orders_statics#ordersPerHour'
  get 'orders/mostOrdersTime', to: 'orders_statics#mostOrdersTime'
  get 'orders/heatMapDelivery', to: 'orders_statics#heatMapDelivery'

  get 'users/mostOrdersDay', to: 'users_statics#mostOrdersDay'
  get 'users/mostOrdersWeek', to: 'users_statics#mostOrdersWeek'
  get 'users/noDeliveryTime', to: 'users_statics#noDeliveryTime'
  get 'users/realTimeTracking', to: 'users_statics#realTimeTracking'

  post 'auth/register', to: 'users#register'
  post 'auth/login', to: 'users#login'
  get 'test', to: 'users#test'
end
