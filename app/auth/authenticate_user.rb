class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password

  # Toma los campos
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Devuelve los campos
  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'Wrong credentials'
    nil
  end
end