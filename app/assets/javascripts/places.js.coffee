# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(() ->
  map = new qq.maps.Map document.getElementById('map-container')
  map.panTo new qq.maps.LatLng 40, 120
)
