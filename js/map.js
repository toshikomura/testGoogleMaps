(function() {

  // Loading the Google Maps API
  google.load('maps', 3, {
    'other_params': 'sensor=false&language=en'
  });

  window.onload = function() {
    // set var position and get id
    var mapDiv = document.getElementById( 'map');
    var airport_ctba = new google.maps.LatLng( -25.5300, -49.1700);
    var start_latLng;

    // Checking if geo positioning is available
    if ( geo_position_js.init()) {
      // Try to determine the location of the device
      // Creating a settings object
      var settings = {
        enableHighAccuracy: true
      };

      // Trying to determine the location of the device
      geo_position_js.getCurrentPosition( setPosition, handleError, settings);
    }
    else {
      alert('Geo functionality is not available');
    }

    function handleError(error) {
      alert('Error = ' + error.message);
    }

    function setPosition(position) {
      // Creating a LatLng from the position info
      var latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

      // Adding a marker to the map
      var marker = new google.maps.Marker({
        position: latLng,
        map: map
      });

      // Creating an InfoWindow
      var infoWindow = new google.maps.InfoWindow({
        content: 'You are here!'
      });

      // Adding the InfoWindow to the map
      infoWindow.open(map, marker);

      // Zooming in on the map
      map.setZoom(6);
    }

    // Getting the position
    if ( google.loader.ClientLocation.latitude && google.loader.ClientLocation.longitude) {

      // Defining the position
      start_latLng = new google.maps.LatLng(
        google.loader.ClientLocation.latitude,
        google.loader.ClientLocation.longitude
      );

      // Creating the content for the InfoWindow
      var location = 'You are located in '
      location += google.loader.ClientLocation.address.city + ', ';
      location += google.loader.ClientLocation.address.country;

    }
    else {

      // Providing default values as a fallback
      start_latLng = airport_ctba;
      var location = 'Your location is unknown';
    }

    // set options of the map
    var options = {
      center: start_latLng,
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
    var map = new google.maps.Map( mapDiv, options);

    // get values
    document.getElementById( 'getValues').onclick = function() {
      alert( 'Current Zoom level is ' + map.getZoom());
      alert( 'Current center is ' + map.getCenter());
      alert( 'The current mapType is ' + map.getMapTypeId());
    }

    // set values
    document.getElementById( 'GoYourPosition').onclick = function() {
      map.setOptions({
        center: start_latLng,
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.SATELLITE
        });
    }

    // set values
    document.getElementById( 'GoCollegeUFPRPoli').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng( -25.4500, -49.2337),
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.SATELLITE
        });
    }

    // set values
    document.getElementById( 'GoAirportCTBA').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng( -25.5300, -49.1700),
        zoom: 15,
        mapTypeId: google.maps.MapTypeId.SATELLITE
      });
    }

    // set values
    document.getElementById( 'GoShoppingJardimDasAmericas').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng( -25.45153107470084, -49.2282697297095),
        zoom: 19,
        mapTypeId: google.maps.MapTypeId.SATELLITE
        });
    }

    // set values
    document.getElementById( 'ViewAllMarkers').onclick = function() {
      // Adjusting the map to new bounding box
      map.fitBounds( bounds)
    }

    // set values
    document.getElementById( 'ViewAllMap').onclick = function() {
      map.setOptions({
        center: new google.maps.LatLng( 0, 0),
        zoom: 2,
        mapTypeId: google.maps.MapTypeId.SATELLITE
      });
    }

    // Creating the icon using a sprite
    var typeMarkers = [];
    typeMarkers[ 'image'] = new google.maps.MarkerImage(
      'image/hanggliding.png',
      new google.maps.Size( 71, 71),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 25, 25)
    );

    typeMarkers[ 'image1'] = new google.maps.MarkerImage(
      'image/kitesurfing.png',
      new google.maps.Size( 71, 71),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 25, 25)
    );

    typeMarkers[ 'image2'] = new google.maps.MarkerImage(
      'image/paragliding.png',
      new google.maps.Size( 71, 71),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 25, 25)
    );

    typeMarkers[ 'image3'] = new google.maps.MarkerImage(
      'image/parasailing.png',
      new google.maps.Size( 71, 71),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 25, 25)
    );

    typeMarkers[ 'imageHover'] = new google.maps.MarkerImage(
      'image/hanggliding.png',
      new google.maps.Size( 140, 140),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 35, 35)
    );

    typeMarkers[ 'imageClick'] = new google.maps.MarkerImage(
      'image/hanggliding.png',
      new google.maps.Size( 71, 71),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 50, 50)
    );

    // Creating the shadow
    typeMarkers[ 'shadow'] = new google.maps.MarkerImage(
      'image/shadow.png',
      new google.maps.Size( 90, 90),
      new google.maps.Point( 0, 0),
      new google.maps.Point( 17, 34),
      new google.maps.Size( 25, 25)
    );

    // Creating an array that will contain the coordinates
    var states = [];

    var parana = new google.maps.Marker({
      position: new google.maps.LatLng( -25.2520888, -52.02154150000001),
      icon: typeMarkers[ 'image']
    });

    var sao_paulo = new google.maps.Marker({
      position: new google.maps.LatLng( -23.5489433, -46.6388182),
      icon: typeMarkers[ 'image']
    });

    var rio_de_janeiro = new google.maps.Marker({
      position: new google.maps.LatLng( -22.9035393, -43.20958689999998),
      icon: typeMarkers[ 'image']
    });

    states.push( parana); // PR
    states.push( sao_paulo); // SP
    states.push( rio_de_janeiro); // RJ

    var citys = [];

    var sao_jose_dos_pinhais = new google.maps.Marker({
      position: new google.maps.LatLng( -25.5307489, -49.195815400000015)
    });

    var curitiba = new google.maps.Marker({
      position: new google.maps.LatLng( -25.4283563, -49.273251500000015)
    });

    var sao_paulo_sp = new google.maps.Marker({
      position: new google.maps.LatLng( -23.5489433, -46.6388182)
    });

    var rio_de_janeiro_rj = new google.maps.Marker({
      position: new google.maps.LatLng( -22.9035393, -43.20958689999998)
    });

    citys.push( sao_jose_dos_pinhais); // SJP
    citys.push( curitiba); // CTB
    citys.push( sao_paulo_sp); // SP - SP
    citys.push( rio_de_janeiro_rj); // RJ - RJ

    // Event to clusters
    google.maps.event.addListener( parana, 'click', function() {
      // Setting the zoom level of the map to 12
      map.setZoom( 12);
      // Setting the center of the map to the clicked markers position
      map.setCenter( parana.getPosition());
    });

    google.maps.event.addListener( sao_paulo, 'click', function() {
      // Setting the zoom level of the map to 12
      map.setZoom( 12);
      // Setting the center of the map to the clicked markers position
      map.setCenter( sao_paulo.getPosition());
    });

    google.maps.event.addListener( rio_de_janeiro, 'click', function() {
      // Setting the zoom level of the map to 12
      map.setZoom( 12);
      // Setting the center of the map to the clicked markers position
      map.setCenter( rio_de_janeiro.getPosition());
    });

    var places = [];

    places.push( new google.maps.LatLng( -25.5300, -49.1700)); // airport CTBA
    places.push( new google.maps.LatLng( -25.4500, -49.2337)); // college UFPR Politecnico
    places.push( new google.maps.LatLng( -25.45153107470084, -49.2282697297095)); // shopping Jardim das Américas

    // Declare infowindow as a global variable This will be at placed
    // outside the for-loop just above it
    var infowindow;

    // Declar bounds
    var bounds = new google.maps.LatLngBounds();

    // Adding a marker to the map
    var marker_user = new google.maps.Marker({
      position: start_latLng,
      map: map
    });

    // Check to see if the infowindow already exists
    if ( !infowindow) {
      // Create a new InfoWindow object
      infowindow = new google.maps.InfoWindow();
    }

    // Setting the content of the InfoWindow
    infowindow.setContent( location);

    // Adding the InfoWindow to the map
    infowindow.open( map, marker_user);

    // BEGIN OF FOR
    // Loop to get all places
    for (var i = 0; i < places.length; i++) {
      // Adding the marker as usual
      var marker = new google.maps.Marker({
        position: places[ i],
        map: map,
        icon: typeMarkers[ 'image'],
        shadow: typeMarkers[ 'shadow'],
        title: 'Place number ' + i
      });

      // Wrapping the event listener inside an anonymous function
      // that we immediately invoke and passes the variable i to.
      (function( i, marker) {
        // Creating the event listener. It now has access to the values of
        // i and marker as they were during its creation
        google.maps.event.addListener( marker, 'click', function() {
          // Check to see if the infowindow already exists
          if ( !infowindow) {
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
            infowindow.setContent( content);
          }
          else {
            // Creating the div that will contain the infoWindow
           var detailDivInfo = document.createElement( 'div');
            detailDivInfo.style.width = '150px';
            detailDivInfo.style.height = '250px';

            // Creating the div that will contain the detail map
            var detailDivMap = document.createElement( 'div');
            detailDivMap.style.width = '150px';
            detailDivMap.style.height = '150px';
            document.getElementById( 'map').appendChild( detailDivMap);

            // Creating MapOptions for the overview map
            var overviewOpts = {
              zoom: 14,
              center: marker.getPosition(),
              mapTypeId: map.getMapTypeId(),
              disableDefaultUI: true
            };

            detailMap = new google.maps.Map( detailDivMap, overviewOpts);

            // Create a marker that will show in the detail map
            var detailMarker = new google.maps.Marker({
              position: marker.getPosition(),
              map: detailMap,
              clickable: false
            });

            // We then create a paragraph element that will contain some text
            var p = document.createElement( 'p');
            p.innerHTML = 'This marker is positioned on Shopping Jardim das Américas.';
            //We then create a second paragraph element that will contain the clickable link
            p2 = document.createElement( 'p');
            // Creating the clickable link
            var aZoonIn = document.createElement( 'a');
            aZoonIn.innerHTML = 'Zoom in';
            aZoonIn.href = '#';

            var aZoonOut = document.createElement( 'a');
            aZoonOut.innerHTML = 'Zoom out';
            aZoonOut.href = '#';

            // Adding a click event to the link that performs
            // the zoom in, and cancels its default action
            aZoonIn.onclick = function() {
              // Setting the center of the map to the same as the clicked marker
              detailMap.setCenter( marker.getPosition());
              // Setting the zoom level to 15
              detailMap.setZoom( 15);
              // Canceling the default action
              return false;
            };

            // Adding a click event to the link that performs
            // the zoom out, and cancels its default action
            aZoonOut.onclick = function() {
              // Setting the center of the map to the same as the clicked marker
              detailMap.setCenter(marker.getPosition());
              // Setting the zoom level to 13
              detailMap.setZoom( 13);
              // Canceling the default action
              return false;
            };

            // Appending the two paragraphs to the div datailInfo
            detailDivInfo.appendChild( detailDivMap);

            // Appending the link to the second paragraph element
            p2.appendChild( aZoonIn);
            p2.appendChild( aZoonOut);
            // Appending the two paragraphs to the div datailInfo
            detailDivInfo.appendChild( p);
            detailDivInfo.appendChild( p2);

            // Setting the content of the InfoWindow
            infowindow.setContent( detailDivInfo);
          }
          // END If place is Shopping Jardim das Américas

          // Tying the InfoWindow to the marker
          infowindow.open( map, marker);

          // Opening the InfoWindow when the map loads
          // google.maps.event.trigger(marker, 'click');
        });
      })( i, marker);

      // Extending the bounds object with each LatLng
      bounds.extend( places[ i]);

      // Hover
      google.maps.event.addListener( marker, 'mouseover', function() {
        this.setIcon( typeMarkers[ 'imageHover']);
      });
      google.maps.event.addListener( marker, 'mouseout', function() {
        this.setIcon( typeMarkers[ 'image']);
      });

      // Click
      google.maps.event.addListener( marker, 'mousedown', function() {
        this.setIcon( typeMarkers[ 'imageClick']);
      });
      google.maps.event.addListener( marker, 'mouseup', function() {
        this.setIcon( typeMarkers[ 'imageHover']);
      });
    }
    // END OF FOR

    // Timout of 3s to adjust map
    setTimeout( function(){
      // Adjusting the map to new bounding box
      map.fitBounds( bounds)
    }, 10000);

    // Generate random markers on the map
    // Get bound of the map
    google.maps.event.addListenerOnce( map, 'bounds_changed', function() {
      var bounds = map.getBounds();

      var southWest =  bounds.getSouthWest();
      var northEast = bounds.getNorthEast();
      var latSpan = northEast.lat() - southWest.lat();
      var lngSpan = northEast.lng() - southWest.lng();
      var markers = [];
      var mgr = new MarkerManager( map, {
        'maxZoom': 20,
        'borderPadding': 200,
        'trackMarkers': true
      });

      for (var i = 0; i < 100; i++) {
        var lat = southWest.lat() + latSpan * Math.random();
        var lng = southWest.lng() + lngSpan * Math.random();
        var latlng = new google.maps.LatLng( lat, lng);

        // Creating a marker. Note that we don't add it to the map
        var marker = new google.maps.Marker({
          position: latlng
        });

        // Adding the marker to the markers array
        markers.push( marker);
      }

      // Creating a MarkerClusterer object and adding the markers array to it
      var markerclusterer = new MarkerClusterer( map, markers, {
        'gridSize': 100,
        'zoomOnClick': false
      });

      // Making sure the MarkerManager is properly loaded before we use it
      google.maps.event.addListener( mgr, 'loaded', function() {

        // Adding the markers to the MarkerManager
        mgr.addMarkers( markers, 1);

        // These markers will only be visible between zoom level 1 and 5
        mgr.addMarkers( states, 2, 9);

        // These markers will be visible at zoom level 6 and deeper
        mgr.addMarkers( citys, 10);

        // Adding the markers to the map
        mgr.refresh();
      });

    });

    // Function to find location
    document.getElementById( 'addressButton').onclick = function() {

      // get values
      // Getting a reference to the HTML form
      var form = document.getElementById('addressForm');

      // Catching the forms submit event
      form.onsubmit = function() {
        // Getting the address from the text input
        var address = document.getElementById( 'address').value;

        // Making the Geocoder call
        getCoordinates( map, infowindow, address);

        // BEGIN function getCoordinates
        function getCoordinates( map, infowindow, address) {
          // Var to find location
          var geocoder_address;
          // Check to see if we already have a geocoded object. If not we create one
          if( !geocoder_address) {
            geocoder_address = new google.maps.Geocoder();
          }

          // Creating a GeocoderRequest object
          var geocoderRequest = {
            address: address
          }

          // Making the Geocode request
          geocoder_address.geocode( geocoderRequest, function( results, status) {
            // Check if status is OK before proceeding
            if ( status == google.maps.GeocoderStatus.OK) {

              // Creating a new marker and adding it to the map
              var marker = new google.maps.Marker({
                map: map
              });

              // Setting the position of the marker to the returned location
              marker.setPosition( results[ 0].geometry.location);

              // Check to see if we've already got an InfoWindow object
              if ( !infowindow) {
                // Creating a new InfoWindow
                infowindow = new google.maps.InfoWindow();
              }

              // Creating the content of the InfoWindow to the address
              // and the returned position
              var content = '<div id="info">' +
              '<strong>' + results[ 0].formatted_address + '</strong><br />' +
              'Lat: ' + results[ 0].geometry.location.lat() + '<br />' +
              'Lng: ' + results[ 0].geometry.location.lng() +
              '</div>';

              // Adding the content to the InfoWindow
              infowindow.setContent( content);
              // Opening the InfoWindow
              infowindow.open( map, marker);

            }
            else {
              alert ( "Address not found");
            }
          });
        }
        // END function getCoordinates

        // Preventing the form from doing a page submit
        return false;
      }
    }

    // Creating a JSON object with weather data
    var markersData = { 'marker': [
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
      var marker_aux = markersData.marker[ j];
      // Creating marker
      var marker2 = new google.maps.Marker({
        position: new google.maps.LatLng( marker_aux.lat, marker_aux.lng),
        map: map,
        icon: typeMarkers[ marker_aux.markerType]
      });
      // Wrapping the event listener inside an anonymous function
      // that we immediately invoke and passes the variable i to.
      (function( j, marker2) {
        // Creating the event listener. It now has access to the values of
        // i and marker as they were during its creation
        google.maps.event.addListener( marker2, 'click', function() {
          // Check to see if the infowindow already exists
          if ( !infowindow2) {
            // Create a new InfoWindow object
            infowindow2 = new google.maps.InfoWindow();
          }

          // Creating a video element and setting its attributes
          var video = document.createElement( 'video');
          video.setAttribute( 'src',
          'http://upload.wikimedia.org/wikipedia/commons/3/3f/ACA_Allertor_125_video.ogv');
          video.setAttribute( 'width', '300');
          video.setAttribute( 'height', '200');
          video.setAttribute( 'controls', 'controls');
          video.setAttribute( 'autoplay', 'autoplay');

          // Setting the content of the InfoWindow
          infowindow2.setContent( video);
          // Tying the InfoWindow to the marker
          infowindow2.open( map, marker2);

          // Opening the InfoWindow when the map loads
          // google.maps.event.trigger(marker, 'click');

        });
      })( j, marker2);

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
    polyline.setMap( map);

    // Adding a click event to the map object
    google.maps.event.addListener( map, 'click', function(e) {

      // Getting a reference to the MVCArray
      var path = polyline.getPath();
      // Adding the position clicked which is in fact
      // a google.maps.LatLng object to the MVCArray
      path.push( e.latLng);

      // Getting the address for the position being clicked
      getAddress( map, infowindow, e.latLng);

      // BEGIN function getCoordinates
      function getAddress( map, infowindow, latLng) {

        // Var to find location
        var geocoder_reverse
        // Check to see if a geocoder object already exists
        if ( !geocoder_reverse) {
          geocoder_reverse = new google.maps.Geocoder();
        }

        // Creating a GeocoderRequest object
        var geocoderRequest = {
          latLng: latLng
        }

        geocoder_reverse.geocode( geocoderRequest, function( results, status) {
          // If the infoWindow hasn't yet been created we create it
          if ( !infowindow) {
            infowindow = new google.maps.InfoWindow();
          }

          // Setting the position for the InfoWindow
          infowindow.setPosition( latLng);

          // Creating content for the InfoWindow
          var content = '<h3>Position: ' + latLng.toUrlValue() + '</h3>';
          // Check to see if the request went allright
          if ( status == google.maps.GeocoderStatus.OK) {
            // Looping through the result
            for ( var i = 0; i < results.length; i++) {
              if ( results[ 0].formatted_address) {
                content += i + '. ' + results[ i].formatted_address + '<br />';
              }
            }
          }
          else {
            content += '<p>No address could be found. Status = ' + status + '</p>';
          }

          // Adding the content to the InfoWindow
          infowindow.setContent( content);
          // Opening the InfoWindow
          infowindow.open( map);
        });

      }
      // END function getCoordinates

    });

    // Create polygon
    var points1 = [
      new google.maps.LatLng( markersData.marker[0].lat, markersData.marker[0].lng),
      new google.maps.LatLng( markersData.marker[1].lat, markersData.marker[1].lng),
      new google.maps.LatLng( markersData.marker[2].lat, markersData.marker[2].lng)
    ];

    var points2 = [
      new google.maps.LatLng( markersData.marker[3].lat, markersData.marker[3].lng),
      new google.maps.LatLng( markersData.marker[4].lat, markersData.marker[4].lng),
      new google.maps.LatLng( markersData.marker[5].lat, markersData.marker[5].lng)
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

    // Change color polygon when mouse over
    google.maps.event.addListener( polygon, 'mouseover', function() {
      polygon.setOptions({
        fillColor: '#0000ff',
        strokeColor: '#0000ff'
      });
    });

    // Return color polygon when mouse out
    google.maps.event.addListener( polygon, 'mouseout', function() {
      polygon.setOptions({
        fillColor: '#ff0000',
        strokeColor: '#00ff00'
      });
    });

  }

})();
