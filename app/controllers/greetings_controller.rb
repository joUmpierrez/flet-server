class GreetingsController < ApplicationController
  attr_reader :current_user

  skip_before_action :authenticate_request, only: %i[hello] # Autenticacion, permite usar la API si hay un token
  load_and_authorize_resource :except => [:hello]# Autenticacion, permite usar la API si el usuario es de tipo administrador

  def hello
    puts :current_user
  end
end
