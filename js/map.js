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
      backgroundColor: '#000000',
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
    document.getElementById('GoCollegeUFPRPoli').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng(-25.4500, -49.2337),
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.SATELLITE
        });
    }

    // set values
    document.getElementById('GoAirportCTBA').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng(-25.5300, -49.1700),
        zoom: 15,
        mapTypeId: google.maps.MapTypeId.SATELLITE
      });
    }

    // Creating an array that will contain the coordinates
    // for New York, San Francisco, and Seattle
    var places = [];

    places.push(new google.maps.LatLng(-25.5300, -49.1700)); // airport CTBA
    places.push(new google.maps.LatLng(-25.4500, -49.2337)); // college UFPR Politecnico

    // Declare infowindow as a global variable This will be at placed
    // outside the for-loop just above it
    var infowindow;

    // Loop to get all places
    for (var i = 0; i < places.length; i++) {
      // Adding the marker as usual
      var marker = new google.maps.Marker({
        position: places[i],
        map: map,
        title: 'Place number ' + i
      });
      // Wrapping the event listener inside an anonymous function
      // that we immediately invoke and passes the variable i to.
      (function(i, marker) {
        // Creating the event listener. It now has access to the values of
        // i and marker as they were during its creation
        google.maps.event.addListener(marker, 'click', function() {
          // Check to see if the infowindow already exists
          if (!infowindow) {
            // Create a new InfoWindow object
            infowindow = new google.maps.InfoWindow();
          }
          // Setting the content of the InfoWindow
          infowindow.setContent('Place number ' + i);
          // Tying the InfoWindow to the marker
          infowindow.open(map, marker);
        });
      })(i, marker);
    }
  }
})();
