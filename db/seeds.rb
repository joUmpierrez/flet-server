# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

=begin
######  Roles  ######
roles_list = %w(Administrador Delivery)

roles_list.each do |name|
  Role.create(name: name)
end
=end

##### Empresas #####
merchants_list = [
    ["171717171", "Empresa Integrador Principal"],
    ["099099099", "Empresa Fantasia SA"],
    ["088088088", "Empresa Recreativa SA"],
    ["077077077", "Empresa Virtual SA"],
    ["066066066", "Empresa Demo SA"],
    ["055055055", "Empresa Ocio SA"],
]

merchants_list.each do |rut, business_name|
  Merchant.create(rut: rut, business_name: business_name)
end

###### Usuarios #####
users_list = [
    ["pablo@admin.com", "pablo", "Pablo", "Diaz", "099999999", "CI", "1111111-1", 1, "admin"],
    ["gaston@admin.com", "gaston", "Gaston", "Cabana", "088888888", "CI", "2222222-2", 1, "admin"],
    ["joaquin@admin.com", "joaquin", "Joaquin", "Umpierrez", "077777777", "CI", "3333333-3", 1, "admin"],
    ["pablo@delivery.com", "pablo", "Pablo", "Diaz", "099999999", "CI", "1111111-1", 1, "delivery"],
    ["gaston@delivery.com", "gaston", "Gaston", "Cabana", "088888888", "CI", "2222222-2", 1, "delivery"],
    ["joaquin@delivery.com", "joaquin", "Joaquin", "Umpierrez", "077777777", "CI", "3333333-3", 1, "delivery"]
]

users_list.each do |email, password, name, lastname, phone, document_type, document_number, merchant_id, role|
  User.create(email: email, password: password, name: name, lastname: lastname, phone: phone, document_type: document_type,
              document_number: document_number, merchant_id: merchant_id, role: role)
end

=begin
### Roles_usuario ###
# Id 1 es admin
# Id 2 es Delivery
User.find(1).add_role(:administrador)
User.find(2).add_role(:administrador)
User.find(3).add_role(:administrador)
User.find(4).add_role(:delivery)
User.find(5).add_role(:delivery)
User.find(6).add_role(:delivery)
=end