class UsersStaticsController < ApplicationController
  require 'net/http'
  require 'json'
  require "ostruct"

  # Autenticacion, permite usar la API si hay un token
  skip_before_action :authenticate_request, only: %i[mostOrdersDay mostOrdersWeek noDeliveryTime realTimeTracking]
  # Autenticacion, permite usar la API si el usuario es de tipo administrador
  load_and_authorize_resource :except => [:mostOrdersDay, :mostOrdersWeek, :noDeliveryTime, :realTimeTracking]

  def getOrders
    urlOrders = 'https://server-mockup.herokuapp.com/orders'
    uriOrders = URI(urlOrders)
    responseOrders = Net::HTTP.get(uriOrders)
    @json_orders = JSON.parse(responseOrders, object_class: OpenStruct)

    return @json_orders
  end

  def getUsers
    urlUsers = 'https://server-mockup.herokuapp.com/users'
    uriUsers = URI(urlUsers)
    responseUsers = Net::HTTP.get(uriUsers)
    @json_users = JSON.parse(responseUsers)

    return @json_users
  end

  def getOrdersDay
    urlOrdersDay = 'https://server-mockup.herokuapp.com/ordersDay'
    uriOrdersDay = URI(urlOrdersDay)
    responseOrdersDay = Net::HTTP.get(uriOrdersDay)
    @json_ordersDay = JSON.parse(responseOrdersDay, object_class: OpenStruct)

    return @json_ordersDay
  end

  def getOrdersWeek
    urlOrdersWeek = 'https://server-mockup.herokuapp.com/ordersWeek'
    uriOrdersWeek = URI(urlOrdersWeek)
    responseOrdersWeek = Net::HTTP.get(uriOrdersWeek)
    @json_ordersWeek = JSON.parse(responseOrdersWeek, object_class: OpenStruct)

    return @json_ordersWeek
  end

  def getOrdersNoDeliveries
    urlOrderNoDeliveries = 'https://server-mockup.herokuapp.com/noDeliverieOrders'
    uriOrderNoDeliveries = URI(urlOrderNoDeliveries)
    responseOrderNoDeliveries = Net::HTTP.get(uriOrderNoDeliveries)
    @json_OrderNoDeliveries = JSON.parse(responseOrderNoDeliveries, object_class: OpenStruct)

    return @json_OrderNoDeliveries
  end

  def getDeliveriesTest
    urlDeliveriesTest = 'https://server-mockup.herokuapp.com/deliveriesTest'
    uriDeliveriesTest = URI(urlDeliveriesTest)
    responseDeliveriesTest = Net::HTTP.get(uriDeliveriesTest)
    @json_deliveriesTest = JSON.parse(responseDeliveriesTest)

    return @json_deliveriesTest
  end

  def mostOrdersDay
    @ordersDay = getOrdersDay
    @users = getDeliveriesTest
    @ordersDeliveredDay = @ordersDay.select{ |order| order.status == "delivered"} # Todas las ordenes que ya han sido entregadaos
    @ordersDeliveredToday = [] #Ordenes entregadas hoy
    @usersOrdersDayAllUsers = [] #Todos los usuarios que entregaron ordenes hoy (repetidos)
    @usersOrdersDayUsers = [] #Todos los usuarios que entregaron ordenes hoy (unicos)
    @usersOrdersDayUsersCount = [] #Todos los usuarios que entregaron ordenes hoy (con id de usuario y cantidad de veces)
    @mostOrdersDay = []

    #Busca todas las ordenes que han sido entregadas hoy
    @ordersDeliveredDay.each do |i|
      if (i.drop_off.effective_date == Date.today.to_s)
        @ordersDeliveredToday.push(i)
      end
    end

    #Limpia todos los arreglos
    @usersOrdersDayAllUsers.clear
    @usersOrdersDayUsers.clear
    @usersOrdersDayUsersCount.clear
    @mostOrdersDay.clear

    # Obtiene todos los id de los usuarios y los guarda en un arreglo y guarda en otro arreglo todos los ids sin repetir
    @ordersDeliveredToday.each do |i|
      @usersOrdersDayAllUsers.push(i.drop_off.user_id)
      if (!@usersOrdersDayUsers.include? i.drop_off.user_id)
        @usersOrdersDayUsers.push(i.drop_off.user_id)
      end
    end

    # Crea un arreglo de objetos que incluye el usuario y la cantidad de pedidos que repartio
    @usersOrdersDayUsers.each do |e|
      @id = e.to_s
      @user = @users.find{|e| e["id"] == @id.to_i}
      @count = @usersOrdersDayAllUsers.count(e)
      obj = {user: @user, count: @count}
      @usersOrdersDayUsersCount.push(obj)
    end

    # Ordenar el arreglo de mayor a menor
    @mostOrdersDay = @usersOrdersDayUsersCount.sort_by { |hsh| hsh[:count]  * -1 }

    render json: @mostOrdersDay
  end

  def mostOrdersWeek
    @ordersWeek = getOrdersWeek
    @users = getDeliveriesTest
    @ordersDeliveredWeek = @ordersWeek.select{ |order| order.status == "delivered"} # Todas las ordenes que ya han sido entregadaos
    @ordersDeliveredWeekday = [] #Ordenes entregadas esta semana
    @usersOrdersWeekAllUsers = [] #Todos los usuarios que entregaron ordenes esta semana (repetidos)
    @usersOrdersWeekUsers = [] #Todos los usuarios que entregaron ordenes esta semana (unicos)
    @usersOrdersWeekUsersCount = [] #Todos los usuarios que entregaron ordenes esta semana (con id de usuario y cantidad de veces)
    @mostOrdersWeek = []

    #Busca todas las ordenes que han sido entregadas esta semana
    @ordersDeliveredWeek.each do |i|
      @currentWeek = Time.now.strftime('%W')
      @dateWeek = Date.parse(i.drop_off.effective_date).strftime('%W')

      if (@dateWeek == @currentWeek)
        @ordersDeliveredWeekday.push(i)
      end
    end

    #Limpia todos los arreglos
    @usersOrdersWeekAllUsers.clear
    @usersOrdersWeekUsers.clear
    @usersOrdersWeekUsersCount.clear
    @mostOrdersWeek.clear

    # Obtiene todos los id de los usuarios y los guarda en un arreglo y guarda en otro arreglo todos los ids sin repetir
    @ordersDeliveredWeekday.each do |i|
      @usersOrdersWeekAllUsers.push(i.drop_off.user_id)
      if (!@usersOrdersWeekUsers.include? i.drop_off.user_id)
        @usersOrdersWeekUsers.push(i.drop_off.user_id)
      end
    end

    # Crea un arreglo de objetos que incluye el usuario y la cantidad de pedidos que repartio
    @usersOrdersWeekUsers.each do |e|
      @id = e.to_s
      @user = @users.find{|e| e["id"] == @id.to_i}
      @count = @usersOrdersWeekAllUsers.count(e)
      obj = {user: @user, count: @count}
      @usersOrdersWeekUsersCount.push(obj)
    end

    # Ordenar el arreglo de mayor a menor
    @mostOrdersWeek = @usersOrdersWeekUsersCount.sort_by { |hsh| hsh[:count]  * -1 }

    render json: @mostOrdersWeek
  end

  def noDeliveryTime
    #@orders = getOrders
    #@users = getUsers
    @orders = getOrdersNoDeliveries
    @users = getDeliveriesTest

    @ordersDelivered = @orders.select{ |order| order.status == "delivered"} # Todas las ordenes que ya han sido entregadaos
    @usersNoDeliverie = [] #Todos los usuarios que entregaron ordenes y sus tiempos sin repartir (repetidos)
    @usersFull = [] # Informacion completa de los usuarios en el JSON

    #Limpia todos los arreglos
    @usersNoDeliverie.clear
    @usersFull.clear

    # Crea un arreglo de objetos que incluye el usuario y los tiempos de demora
    @orders.each do |e|
      @id = e.drop_off.user_id

      @currentDate = DateTime.now
      @parsedDate = Date.parse(e.drop_off.effective_date)
      @parsedTime = Time.parse(e.drop_off.effective_time)
      @parsedDateTime = DateTime.parse([ @parsedDate, @parsedTime ].join(' '))
      @differenceInSeconds = ((@currentDate - @parsedDateTime) * 24 * 60 * 60).to_i
      @differenceInDays = ((@currentDate - @parsedDateTime)).to_i
      @difference = Time.at(@differenceInSeconds).utc.strftime("%H:%M:%S")
      @differenceHours = @difference.slice(0, 2).to_i + 24*@differenceInDays
      @differenceMinutes = @difference.slice(3, 2).to_i
      @differenceSeconds = @difference.slice(6, 2).to_i

      if (@usersNoDeliverie.empty?)
        obj = {
            user: @id,
            noDeliverySeconds: @differenceInSeconds,
            noDeliveryTime: {
                hours: @differenceHours,
                minutes: @differenceMinutes,
                seconds: @differenceSeconds
            }
        }

        @usersNoDeliverie.push(obj)
      else
        if (@usersNoDeliverie.none? {|obj| obj[:user] == @id})
          obj = {
              user: @id,
              noDeliverySeconds: @differenceInSeconds,
              noDeliveryTime: {
                  hours: @differenceHours,
                  minutes: @differenceMinutes,
                  seconds: @differenceSeconds
              }
          }

          @usersNoDeliverie.push(obj)
        else
          @findValue = @usersNoDeliverie.find {|e| e[:user] == @id}

          if (@findValue[:noDeliverySeconds] > @differenceInSeconds)
            @findValue[:noDeliverySeconds] = @differenceInSeconds
            @findValue[:noDeliveryTime][:hours] = @differenceHours
            @findValue[:noDeliveryTime][:minutes] = @differenceMinutes
            @findValue[:noDeliveryTime][:seconds] = @differenceSeconds
          end
        end
      end
    end

    # Completa el arreglo con la informacion completa de los usuarios
    @usersNoDeliverie.each do |e|
      @id = e[:user]
      @user = @users.find {|usr| usr["id"] == @id}
      @noDeliverySeconds = e[:noDeliverySeconds]
      @noDeliveryTime = e[:noDeliveryTime]

      obj = {
          user: @user,
          noDeliverySeconds: @noDeliverySeconds,
          noDeliveryTime: @noDeliveryTime
      }

      @usersFull.push(obj)
    end

    render json: @usersFull
  end

  def realTimeTracking

  end
end
