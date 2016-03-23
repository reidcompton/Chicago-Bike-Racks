class HomeController < ApplicationController
	def index
		@ip = request.remote_ip == '::1' ? '205.178.100.103' : request.remote_ip
		@info = GeoIP.new(Rails.root.join("GeoLiteCity.dat")).city(@ip)
		@long = @info.longitude
		@lat = @info.latitude
	end

	def getBikes 
		@lat = params[:lat]
		@long = params[:long]
		@response = HTTParty.get('http://data.cityofchicago.org/resource/cbyb-69xx.json?$select=location.longitude%2C%20location.latitude&$where=within_circle(location%2C%20' + @lat + '%2C%20' + @long + '%2C%20322)')
		render :json => @response
	end
end
