(function() {
  window.onload = function() {
    // set var position and get id
    var mapDiv = document.getElementById('map');
    var airport_ctba = new google.maps.LatLng(-25.5300, -49.1700);

    // set options of the map
    var options = {
      center: airport_ctba,
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.SATELLITE,

      // set control options of the map
      mapTypeControl: true,
      mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
        position: google.maps.ControlPosition.TOP,
        mapTypeIds: [
          google.maps.MapTypeId.ROADMAP,
          google.maps.MapTypeId.SATELLITE
        ]
      },

      // set function of the map
      scaleControl: true,
      keyboardShortcuts: true,
      disableDoubleClickZoom: false,
      draggable: true,
      scrollwheel: true,
      streetViewControl: true,

      // set navigation of the map
      disableDefaultUI: false,
      navigationControl: true,
      navigationControlOptions: {
        position: google.maps.ControlPosition.TOP_LEFT,
        style: google.maps.NavigationControlStyle.ZOOM_PAN
      },

      // set container of the map
      noClear: false,
      backgroundColor: '#ff0000',
      draggableCursor: 'move',
      draggingCursor: 'move'
    };

    // create map
    var map = new google.maps.Map(mapDiv, options);

    // get values
    document.getElementById('getValues').onclick = function() {
      alert('Current Zoom level is ' + map.getZoom());
      alert('Current center is ' + map.getCenter());
      alert('The current mapType is ' + map.getMapTypeId());
    }

    // set values
    document.getElementById('changeValues').onclick = function() {
      var college_ufpr_poli = new google.maps.LatLng(-25.4500, -49.2337);
      map.setCenter(college_ufpr_poli);
      map.setZoom(16);
      map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
    }

 }
})();
