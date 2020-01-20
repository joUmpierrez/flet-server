class User < ApplicationRecord
  has_secure_password

  # Validaciones
  validates :email, uniqueness: true
  validates_presence_of :name, :lastname, :phone, :document_type, :document_number
end
