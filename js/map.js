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

    // Adding a marker to the map point to college ufpr politecnico
    var marker_college_ufpr_poli = new google.maps.Marker({
      position: new google.maps.LatLng(-25.4500, -49.2337),
      map: map,
      title: 'College UFPR Politecnico',
      icon: 'http://gmaps-samples.googlecode.com/svn/trunk/markers/blue/blank.png'
    });

    // Adding a marker to the map point to airpot CTBA PR BR
    var marker_college_ufpr_poli = new google.maps.Marker({
      position: new google.maps.LatLng(-25.5300, -49.1700),
      map: map,
      title: 'Airport CTBA',
      icon: 'http://gmaps-samples.googlecode.com/svn/trunk/markers/circular/greencirclemarker.png'
    });

    // Creating an InfoWindow with the content text
    var infowindow_college_ufpr_poli = new google.maps.InfoWindow({
      content:'<div class="info"> This is College UFPR Politecnico </div>'
    });

    // Creating an InfoWindow with the content text
    var infowindow_airport_ctba = new google.maps.InfoWindow({
      content:'<div class="info"> This is Airport CTBA </div>'
    });

    // Adding a click event to the marker
    google.maps.event.addListener(marker_college_ufpr_poli, 'click', function() {
      // Calling the open method of the infoWindow
      infowindow_college_ufpr_poli.open(map, marker_college_ufpr_poli);
    });

    // Adding a click event to the marker
    google.maps.event.addListener(marker_airport_ctba, 'click', function() {
      // Calling the open method of the infoWindow
      infowindow_airport_ctba.open(map, marker_airport_ctba);
    });
 }
})();
