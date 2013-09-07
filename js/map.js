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
      backgroundColor: 'black',
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

    // set values
    document.getElementById('ViewAllMarkers').onclick = function() {
      // Adjusting the map to new bounding box
      map.fitBounds(bounds)
    }

    // Creating the icon using a sprite
    var typeMarkers = [];
    typeMarkers['image'] = new google.maps.MarkerImage(
      'image/hanggliding.png',
      new google.maps.Size(71, 71),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(25, 25)
    );

    typeMarkers['image1'] = new google.maps.MarkerImage(
      'image/kitesurfing.png',
      new google.maps.Size(71, 71),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(25, 25)
    );

    typeMarkers['image2'] = new google.maps.MarkerImage(
      'image/paragliding.png',
      new google.maps.Size(71, 71),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(25, 25)
    );

    typeMarkers['image3'] = new google.maps.MarkerImage(
      'image/parasailing.png',
      new google.maps.Size(71, 71),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(25, 25)
    );

    typeMarkers['imageHover'] = new google.maps.MarkerImage(
      'image/hanggliding.png',
      new google.maps.Size(140, 140),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(35, 35)
    );

    typeMarkers['imageClick'] = new google.maps.MarkerImage(
      'image/hanggliding.png',
      new google.maps.Size(71, 71),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(50, 50)
    );

    // Creating the shadow
    typeMarkers['shadow'] = new google.maps.MarkerImage(
      'image/shadow.png',
      new google.maps.Size(90, 90),
      new google.maps.Point(0, 0),
      new google.maps.Point(17, 34),
      new google.maps.Size(25, 25)
    );

    // Creating an array that will contain the coordinates
    // for New York, San Francisco, and Seattle
    var places = [];

    places.push(new google.maps.LatLng(-25.5300, -49.1700)); // airport CTBA
    places.push(new google.maps.LatLng(-25.4500, -49.2337)); // college UFPR Politecnico

    // Declare infowindow as a global variable This will be at placed
    // outside the for-loop just above it
    var infowindow;

    // Declar bounds
    var bounds = new google.maps.LatLngBounds();

    // Loop to get all places
    for (var i = 0; i < places.length; i++) {
      // Adding the marker as usual
      var marker = new google.maps.Marker({
        position: places[i],
        map: map,
        icon: typeMarkers['image'],
        shadow: typeMarkers['shadow'],
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

      // Extending the bounds object with each LatLng
      bounds.extend(places[i]);

      // Hover
      google.maps.event.addListener(marker, 'mouseover', function() {
        this.setIcon(typeMarkers['imageHover']);
      });
      google.maps.event.addListener(marker, 'mouseout', function() {
        this.setIcon(typeMarkers['image']);
      });

      // Click
      google.maps.event.addListener(marker, 'mousedown', function() {
        this.setIcon(typeMarkers['imageClick']);
      });
      google.maps.event.addListener(marker, 'mouseup', function() {
        this.setIcon(typeMarkers['imageHover']);
      });
    }

    // Timout of 3s to adjust map
    setTimeout(function(){
      // Adjusting the map to new bounding box
      map.fitBounds(bounds)
    },3000);

    // Creating a JSON object with weather data
    var markersData = {'marker': [
      {
        'lat': 40.756054,
        'lng': -73.986951,
        'markerType': 'image1'
      },
      {
        'lat': 47.620973,
        'lng': -122.347276,
        'markerType': 'image2'
      },
      {
        'lat': 37.775206,
        'lng': -122.419209,
        'markerType': 'image3'
      }
    ]};

    // Looping through the weather array in weatherData
    for (var i = 0; i < markersData.marker.length; i++) {
      // creating a variable that will hold the current weather object
      var marker_aux = markersData.marker[i];
        // Creating marker
        var marker2 = new google.maps.Marker({
          position: new google.maps.LatLng(marker_aux.lat, marker_aux.lng),
          map: map,
          icon: typeMarkers[marker_aux.markerType]
        });
    }

  }
})();
