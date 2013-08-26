(function() {
  window.onload = function() {
    var mapDiv = document.getElementById('map');
    var latlng = new google.maps.LatLng(-25.5300, -49.1700);

    var options = {
      center: latlng,
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.SATELLITE,

      mapTypeControl: true,
      mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
        position: google.maps.ControlPosition.TOP,
        mapTypeIds: [
          google.maps.MapTypeId.ROADMAP,
          google.maps.MapTypeId.SATELLITE
        ]
      },

      scaleControl: true,
      keyboardShortcuts: true,
      disableDoubleClickZoom: false,
      draggable: true,
      scrollwheel: true,
      streetViewControl: true,

      disableDefaultUI: false,
      navigationControl: true,
      navigationControlOptions: {
        position: google.maps.ControlPosition.TOP_LEFT,
        style: google.maps.NavigationControlStyle.ZOOM_PAN
      },

      noClear: false,
      backgroundColor: '#ff0000',
      draggableCursor: 'move',
      draggingCursor: 'move'
    };

    var map = new google.maps.Map(mapDiv, options);

    document.getElementById('getValues').onclick = function() {
      alert('Current Zoom level is ' + map.getZoom());
      alert('Current center is ' + map.getCenter());
      alert('The current mapType is ' + map.getMapTypeId());
    }


    document.getElementById('changeValues').onclick = function() {
      var latLng = new google.maps.LatLng(-25.4500, -49.2337);
      map.setCenter(latLng);
      map.setZoom(16);
    }

 }
})();
