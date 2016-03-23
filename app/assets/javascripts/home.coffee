# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->

	$('#LocationSubmit').off('click').on 'click', ->
		getBikes()

	getBikes = ->
		if navigator.geolocation
			navigator.geolocation.getCurrentPosition plotBikeRacks
		else
			alert 'Geolocation is not supported by this browser.'

	plotBikeRacks = (position) ->
		$('#input-box').addClass('active')
		bindReactive()
		latitude = parseFloat(position.coords.latitude.toFixed(6))
		longitude = parseFloat(position.coords.longitude.toFixed(6))
		queryDataPortal latitude, longitude

	queryDataPortal = (latitude, longitude) ->
		$.ajax
			url: '/home/getBikes'
			data:
				lat: latitude
				long: longitude
			success: (data) ->
				initGoogleMaps(latitude, longitude, data)

	initGoogleMaps = (latitude, longitude, data) ->
		mapOptions = 
			center: new (google.maps.LatLng)(latitude, longitude)
			zoom: 17
			mapTypeId: google.maps.MapTypeId.ROADMAP
		map = new (google.maps.Map)(document.getElementById('map-overwrite'), mapOptions)
		mapMarkers longitude, latitude, data, map, true
		google.maps.event.addListener map, 'idle', ->
			center = map.getCenter()
			latitude = center.lat()
			longitude = center.lng()
			queryDataPortal latitude, longitude, null, map
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
				icon: '/bike.png')
			markerBikes = marker.setMap(map)

	bindReactive = ->
		$('#input-box.active').off('click').on 'click', ->
			$('#input-box.active').removeClass 'active'
 
return	