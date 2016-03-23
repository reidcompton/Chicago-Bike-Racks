# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->

	#events 
	$('#LocationSubmit').off('click').on 'click', ->
		getBikesByLatLong()

	$('#AddressSubmit').off('click').on 'click', ->
		getBikesByAddress $('#address').val()

	$(window).keypress (e) -> 
		if e.which == 13
			getBikesByAddress $('#address').val()

	getBikesByLatLong = ->
		if navigator.geolocation
			navigator.geolocation.getCurrentPosition plotBikeRacksGeolocation
		else
			alert 'Geolocation is not supported by this browser.'

	getBikesByAddress = (address) ->
		geoCodeAddress address

	geoCodeAddress = (address) ->
		$.ajax
			url: '/home/getBikesByAddress'
			data: 
				address: address
			success: (data) ->
				if data.results.length > 0
					plotBikeRacks data.results[0].geometry.location.lat, data.results[0].geometry.location.lng
				else
					alert "Sorry, address not found"

	plotBikeRacksGeolocation = (position) ->
		$('#input-box').addClass('active')
		bindReactive()
		queryDataPortal parseFloat(position.coords.latitude.toFixed(6)), parseFloat(position.coords.longitude.toFixed(6))

	plotBikeRacks = (latitude, longitude) ->
		$('#input-box').addClass('active')
		bindReactive()
		queryDataPortal latitude, longitude

	queryDataPortal = (latitude, longitude) ->
		$.ajax
			url: '/home/getBikesByLatLong'
			data:
				lat: latitude
				long: longitude
			success: (data) ->
				initGoogleMaps(latitude, longitude, data)

	queryClientSideDataPortal = (latitude, longitude, map) ->
		$.getJSON 'http://data.cityofchicago.org/resource/cbyb-69xx.json?$select=location.longitude%2C%20location.latitude&$where=within_circle(location%2C%20' + latitude + '%2C%20' + longitude + '%2C%20322)', (data) ->
				mapMarkers longitude, latitude, data, map
		return

	initGoogleMaps = (latitude, longitude, data) ->
		mapOptions = 
			center: new (google.maps.LatLng)(latitude, longitude)
			zoom: 17
			mapTypeId: google.maps.MapTypeId.ROADMAP
		map = new (google.maps.Map)(document.getElementById('map-overwrite'), mapOptions)
		mapMarkers longitude, latitude, data, map, true
		google.maps.event.addListener map, 'mouseup', ->
			center = map.getCenter()
			latitude = center.lat()
			longitude = center.lng()
			queryClientSideDataPortal latitude, longitude, map
			true
		true

	mapMarkers = (longitude, latitude, data, map) ->
		me = new (google.maps.Marker)(
			position: new (google.maps.LatLng)(latitude, longitude)
			title: 'My Location')
		markerMe = me.setMap(map)
		$(data).each ->
			marker = new (google.maps.Marker)(
				position: new (google.maps.LatLng)(@sub_col_location_latitude, @sub_col_location_longitude)
				title: 'Bike Rack'
				icon: {
					url: '/bike.png',
					scaledSize: new google.maps.Size(45,29)
				})
			markerBikes = marker.setMap(map)

	bindReactive = ->
		$('#input-box.active').off('click').on 'click', ->
			$('#input-box.active').removeClass 'active'
 
return	