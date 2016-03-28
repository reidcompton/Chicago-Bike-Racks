class HomeController < ApplicationController
	def index
		ip = (request.remote_ip == '::1' || request.remote_ip == '127.0.0.1') ? '50.252.126.42' : request.remote_ip
		info = GeoIP.new(Rails.root.join("GeoLiteCity.dat")).city(ip)
		@long = info.longitude
		@lat = info.latitude
	end

	def getBikesByLatLong 
		lat = params[:lat]
		long = params[:long]
		response = HTTParty.get("https://data.cityofchicago.org/resource/cbyb-69xx.json?$select=location.longitude%2C%20location.latitude&$where=within_circle(location%2C%20" + lat + "%2C%20" + long + "%2C%20322)")
		render :json => response
	end

	def getBikesByAddress
		address = params[:address]
		response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=AIzaSyBXUgBqKjqv-75O6SfPwZVe2hwhxorg0RM")
		render :json => response
	end
end
