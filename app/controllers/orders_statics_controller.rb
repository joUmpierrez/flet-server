class OrdersStaticsController < ApplicationController
  require 'net/http'
  require 'json'
  require "ostruct"

  # Autenticacion, permite usar la API si hay un token
  skip_before_action :authenticate_request, only: %i[mostOrdersTime ordersPerHour heatMapDelivery]
  # Autenticacion, permite usar la API si el usuario es de tipo administrador
  load_and_authorize_resource :except => [:mostOrdersTime, :ordersPerHour, :heatMapDelivery]

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

  def getDeliveriesTest
    urlDeliveriesTest = 'https://server-mockup.herokuapp.com/deliveriesTest'
    uriDeliveriesTest = URI(urlDeliveriesTest)
    responseDeliveriesTest = Net::HTTP.get(uriDeliveriesTest)
    @json_deliveriesTest = JSON.parse(responseDeliveriesTest)

    return @json_deliveriesTest
  end

  def getOrdersTimesTest
    urlOrdersTimesTest = 'https://server-mockup.herokuapp.com/ordersTimesTest'
    uriOrdersTimesTest= URI(urlOrdersTimesTest)
    responseOrdersTimesTest = Net::HTTP.get(uriOrdersTimesTest)
    @json_OrdersTimesTest = JSON.parse(responseOrdersTimesTest, object_class: OpenStruct)

    return @json_OrdersTimesTest
  end

  def getOrdersHour
    urlOrdersHour = 'https://server-mockup.herokuapp.com/ordersHour'
    uriOrdersHour = URI(urlOrdersHour)
    responseOrdersHour = Net::HTTP.get(uriOrdersHour)
    @json_OrdersHour = JSON.parse(responseOrdersHour, object_class: OpenStruct)

    return @json_OrdersHour
  end

  def getLocationsForAPI
    urlLocationsForAPI = 'https://server-mockup.herokuapp.com/locationsForAPI'
    uriLocationsForAPI = URI(urlLocationsForAPI)
    responseLocationsForAPI = Net::HTTP.get(uriLocationsForAPI)
    @json_LocationsForAPI = JSON.parse(responseLocationsForAPI)

    return @json_LocationsForAPI
  end

  def ordersPerHourGeneric
    @orders = getOrdersHour
    @initTime = Time.parse("00:00:00") # La primera hora del dia es declarada para crear un arreglo ordenado
    @timeOrdersCount = Array.new # Arreglo que tiene la hora y la cantidad de ordenes que hubieron en esa hora

    # Limpia todos los arreglos
    @timeOrdersCount.clear

    # Un loop que crea el arreglo para las horas vacio
    for i in 0..23
      @time = @initTime+i.hours
      @timeOrdersCount.push({hour: @time.strftime("%H"), time: @time.strftime("%H:%M:%S"), orders: 0})
    end


    @orders.each do |obj|
      @hourFind = Time.parse(obj[:drop_off][:effective_time]).strftime("%H")
      @timeInArray = @timeOrdersCount.find { |e| e[:hour] == @hourFind  }
      @counter = @timeInArray[:orders]

      @timeInArray[:orders] = @counter+1

    end

    return @timeOrdersCount
  end

  def ordersPerHour
    if params[:sort] == "time"
      @ordersHour = ordersPerHourGeneric.sort_by { |hsh| hsh[:hour] }
    elsif params[:sort] == "orders"
      @ordersHour = ordersPerHourGeneric.sort_by { |hsh| hsh[:orders]  * -1 }
    end

    render json: @ordersHour
  end

  def mostOrdersTime
    @ordersHour = ordersPerHourGeneric.sort_by { |hsh| hsh[:orders]  * -1 }
    @maxValue = @ordersHour[0][:orders]
    @ordersMostHour = @ordersHour.find_all { |hsh| hsh[:orders] == @maxValue}

    render json: @ordersMostHour
  end

  def heatMapDelivery
    @order = getLocationsForAPI
    @coordinates = []

    @order.each do |ord|
      @coordinates.push(ord["drop_off"]["coordinates"])
    end

    render json: @coordinates

  end
end
