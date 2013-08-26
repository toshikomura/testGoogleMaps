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
        position: google.maps.ControlPosition.TOP

      }
    };

    var map = new google.maps.Map(mapDiv, options);
 }
})();
