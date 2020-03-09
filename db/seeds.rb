
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
    ### Administradores ###
    ["pablo@admin.com", "pablo", "Pablo", "Diaz", "099999999", "CI", "1111111-1", 1, "admin"],
    ["gaston@admin.com", "gaston", "Gaston", "Cabana", "088888888", "CI", "2222222-1", 1, "admin"],
    ["joaquin@admin.com", "joaquin", "Joaquin", "Umpierrez", "077777777", "CI", "3333333-1", 1, "admin"],

    ### Repartidores ###
    ["pablo@delivery.com", "pablo", "Pablo", "Diaz", "099999999", "CI", "4444444-1", 1, "delivery"],
    ["gaston@delivery.com", "gaston", "Gaston", "Cabana", "088888888", "CI", "5555555-1", 1, "delivery"],
    ["joaquin@delivery.com", "joaquin", "Joaquin", "Umpierrez", "077777777", "CI", "6666666-1", 1, "delivery"],
]

users_list.each do |email, password, name, lastname, phone, document_type, document_number, merchant_id, role|
  User.create(email: email, password: password, name: name, lastname: lastname, phone: phone, document_type: document_type,
              document_number: document_number, merchant_id: merchant_id, role: role)
end