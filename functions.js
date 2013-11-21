$(document).ready(function(){

  var calcSize; (calcSize = function calcSize () {
          var width = window.innerWidth, 
              height = window.innerHeight;
          $('body').css('height', height).css('width', width);
  })();

  $(window).resize(calcSize);

  (function () {
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition(plotBikeRacks);
    else
      alert("Geolocation is not supported by this browser.");
  })();

  function plotBikeRacks(position) {
    var latitude = parseFloat(position.coords.latitude.toFixed(6)),
    longitude = parseFloat(position.coords.longitude.toFixed(6));

    $.getJSON(('http://data.cityofchicago.org/resource/cbyb-69xx.json?$select=location.longitude%2C%20location.latitude&$where=within_circle(location%2C%20' + latitude + '%2C%20' + longitude + '%2C%20322)'), function (data) {
      var mapOptions = {
        center: new google.maps.LatLng(latitude, longitude),
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      },
      map = new google.maps.Map(document.getElementById('map'), mapOptions),
      me = new google.maps.Marker({
        position: new google.maps.LatLng(latitude, longitude),
        title:'My Location'
      });
      
      $(data).each(function(){
        var marker = new google.maps.Marker({
              position: new google.maps.LatLng(this.sub_col_location_latitude, this.sub_col_location_longitude),
              title: 'Bike Rack',
              icon: 'bike.png'
        });

        me.setMap(map);
        marker.setMap(map);
      });

    });
  }
        	
});