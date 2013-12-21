# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(() ->
  map = new qq.maps.Map document.getElementById 'map-container'
  navigator.geolocation.getCurrentPosition (position) ->
    currentPosition = new qq.maps.LatLng position.coords.latitude, position.coords.longitude
    map.panTo currentPosition
    map.setZoom 15
    new qq.maps.Marker
      position: currentPosition
      map: map
)
