(function() {
  window.onload = function() {
    var mapDiv = document.getElementById('map');
    var latlng = new google.maps.LatLng(-25.5350, -49.2058);

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

      noClear: true,
      backgroundColor: '#ff0000'
    };

    var map = new google.maps.Map(mapDiv, options);
 }
})();
