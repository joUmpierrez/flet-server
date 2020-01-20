class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register addRole]

  # Metodo para registrar un usuario
  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def login
    authenticate params[:email], params[:password]
  end

  def test
    render json: {
        message: 'You have passed authentication and authorization test'
    }
  end

  private
  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
          access_token: command.result,
          message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def user_params
    params.permit(
        :email,
        :password,
        :name,
        :lastname,
        :phone,
        :document_type,
        :document_number
    )
  end
end