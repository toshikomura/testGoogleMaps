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
    document.getElementById('GoShoppingJardimDasAmericas').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng(-25.45153107470084, -49.2282697297095),
        zoom: 19,
        mapTypeId: google.maps.MapTypeId.SATELLITE
        });
    }

    // set values
    document.getElementById('ViewAllMarkers').onclick = function() {
      // Adjusting the map to new bounding box
      map.fitBounds(bounds)
    }

    // set values
    document.getElementById('ViewAllMap').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng( 0, 0),
        zoom: 2,
        mapTypeId: google.maps.MapTypeId.SATELLITE
      });
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
    places.push(new google.maps.LatLng(-25.45153107470084, -49.2282697297095)); // shopping Jardim das Américas

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

          // BEGIN If place is Shopping Jardim das Américas
          if ( i != 2) {
            // Set content to infoWindow
            var content = '<div id="info">' +
            '<img src="image/squirrel.jpg" alt="" />' +
            '<h2>Place '+ i + '</h2>' +
            '<p>Description of place ' + i + '</p>' +
            '<p><a href="http://www.svennerberg.com">A sample link</a></p>' +
            '</div>';

            // Setting the content of the InfoWindow
            infowindow.setContent(content);
          }
          else {
            // Creating the div that will contain the infoWindow
            var detailDivInfo = document.createElement('div');
            detailDivInfo.style.width = '150px';
            detailDivInfo.style.height = '250px';

            // Creating the div that will contain the detail map
            var detailDivMap = document.createElement('div');
            detailDivMap.style.width = '150px';
            detailDivMap.style.height = '150px';
            document.getElementById('map').appendChild(detailDivMap);

            // Creating MapOptions for the overview map
            var overviewOpts = {
              zoom: 14,
              center: marker.getPosition(),
              mapTypeId: map.getMapTypeId(),
              disableDefaultUI: true
            };

            detailMap = new google.maps.Map(detailDivMap, overviewOpts);

            // Create a marker that will show in the detail map
            var detailMarker = new google.maps.Marker({
              position: marker.getPosition(),
              map: detailMap,
              clickable: false
            });

            // We then create a paragraph element that will contain some text
            var p = document.createElement('p');
            p.innerHTML = 'This marker is positioned on Shopping Jardim das Américas.';
            //We then create a second paragraph element that will contain the clickable link
            p2 = document.createElement('p');
            // Creating the clickable link
            var aZoonIn = document.createElement('a');
            aZoonIn.innerHTML = 'Zoom in';
            aZoonIn.href = '#';

            var aZoonOut = document.createElement('a');
            aZoonOut.innerHTML = 'Zoom out';
            aZoonOut.href = '#';

            // Adding a click event to the link that performs
            // the zoom in, and cancels its default action
            aZoonIn.onclick = function() {
              // Setting the center of the map to the same as the clicked marker
              detailMap.setCenter(marker.getPosition());
              // Setting the zoom level to 15
              detailMap.setZoom(15);
              // Canceling the default action
              return false;
            };

            // Adding a click event to the link that performs
            // the zoom out, and cancels its default action
            aZoonOut.onclick = function() {
              // Setting the center of the map to the same as the clicked marker
              detailMap.setCenter(marker.getPosition());
              // Setting the zoom level to 13
              detailMap.setZoom(13);
              // Canceling the default action
              return false;
            };

            // Appending the two paragraphs to the div datailInfo
            detailDivInfo.appendChild(detailDivMap);

            // Appending the link to the second paragraph element
            p2.appendChild(aZoonIn);
            p2.appendChild(aZoonOut);
            // Appending the two paragraphs to the div datailInfo
            detailDivInfo.appendChild(p);
            detailDivInfo.appendChild(p2);

            // Setting the content of the InfoWindow
            infowindow.setContent(detailDivInfo);
          }
          // END If place is Shopping Jardim das Américas

          // Tying the InfoWindow to the marker
          infowindow.open(map, marker);

          // Opening the InfoWindow when the map loads
          // google.maps.event.trigger(marker, 'click');
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
      },
      {
        'lat': 42.756054,
        'lng': -89.986951,
        'markerType': 'image1'
      },
      {
        'lat': 42.620973,
        'lng': -103.347276,
        'markerType': 'image2'
      },
      {
        'lat': 39.775206,
        'lng': -103.419209,
        'markerType': 'image3'
      }
    ]};

    // Declare infowindow as a global variable This will be at placed
    // outside the for-loop just above it
    var infowindow2;

    // Looping through the weather array in weatherData
    for (var j = 0; j < markersData.marker.length; j++) {
      // creating a variable that will hold the current weather object
      var marker_aux = markersData.marker[j];
      // Creating marker
      var marker2 = new google.maps.Marker({
        position: new google.maps.LatLng(marker_aux.lat, marker_aux.lng),
        map: map,
        icon: typeMarkers[marker_aux.markerType]
      });
      // Wrapping the event listener inside an anonymous function
      // that we immediately invoke and passes the variable i to.
      (function(j, marker2) {
        // Creating the event listener. It now has access to the values of
        // i and marker as they were during its creation
        google.maps.event.addListener(marker2, 'click', function() {
          // Check to see if the infowindow already exists
          if (!infowindow2) {
            // Create a new InfoWindow object
            infowindow2 = new google.maps.InfoWindow();
          }

          // Creating a video element and setting its attributes
          var video = document.createElement('video');
          video.setAttribute('src',
          'http://upload.wikimedia.org/wikipedia/commons/3/3f/ACA_Allertor_125_video.ogv');
          video.setAttribute('width', '300');
          video.setAttribute('height', '200');
          video.setAttribute('controls', 'controls');
          video.setAttribute('autoplay', 'autoplay');

          // Setting the content of the InfoWindow
          infowindow2.setContent(video);
          // Tying the InfoWindow to the marker
          infowindow2.open(map, marker2);

          // Opening the InfoWindow when the map loads
          // google.maps.event.trigger(marker, 'click');

        });
      })(j, marker2);

    }

    // Can create var
    //var polylineOptions = {
    //  path: places
    //};

    // Create routes
    var polyline = new google.maps.Polyline({
      path: places,
      map: map,
      strokeColor: "#ff0000",
      strokeWeight: 8,
      strokeOpacity: 0.5
    });
    //polyline.setMap(map);

    // Create new routes
    // Creating an empty MVCArray
    var route = new google.maps.MVCArray();

    // Creating the Polyline object
    var polyline = new google.maps.Polyline({
      path: route,
      strokeColor: "#0000ff",
      strokeOpacity: 0.6,
      strokeWeight: 7
    });

    // Adding the polyline to the map
    polyline.setMap(map);

    // Adding a click event to the map object
    google.maps.event.addListener(map, 'click', function(e) {
      // Getting a reference to the MVCArray
      var path = polyline.getPath();
      // Adding the position clicked which is in fact
      // a google.maps.LatLng object to the MVCArray
      path.push(e.latLng);
    });

    // Create polygon
    var points1 = [
      new google.maps.LatLng(markersData.marker[0].lat, markersData.marker[0].lng),
      new google.maps.LatLng(markersData.marker[1].lat, markersData.marker[1].lng),
      new google.maps.LatLng(markersData.marker[2].lat, markersData.marker[2].lng)
    ];

    var points2 = [
      new google.maps.LatLng(markersData.marker[3].lat, markersData.marker[3].lng),
      new google.maps.LatLng(markersData.marker[4].lat, markersData.marker[4].lng),
      new google.maps.LatLng(markersData.marker[5].lat, markersData.marker[5].lng)
    ];

    var pointsall = [ points1, points2];

    var polygon = new google.maps.Polygon({
      //zIndex: 2,  // indicate sobreposition
      paths: pointsall,
      map: map,
      strokeColor: '#ff0000',
      strokeOpacity: 0.9,
      strokeWeight: 4,
      fillColor: '#00ff00',
      fillOpacity: 0.35
    });

  }
})();
