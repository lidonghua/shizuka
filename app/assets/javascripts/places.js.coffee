# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  mapContainer = document.getElementById 'map-container'
  if mapContainer
    initMap mapContainer
    return
  mapContainer = document.getElementById 'street-map-container'
  if mapContainer
    initStreetMap mapContainer
  $('.color-picker').click () ->
    color = $(this).attr('style').match(/.*background-color:.*(#[abcdef\d]+).*/)[1]
    $('#comment_mood').val color

$(document).ready(ready)
$(document).on('page:load', ready)

initStreetMap = (mapContainer) ->

initMap = (mapContainer) ->
  currentPosition = new qq.maps.LatLng 31.215240, 121.420290 # DianPing
  map = new qq.maps.Map mapContainer
  map.setOptions
    panControl: false
    zoomControl: false
    mapTypeControl: false
    center: currentPosition
    zoom: 15
  navigator.geolocation.getCurrentPosition (position) ->
    currentPosition = new qq.maps.LatLng position.coords.latitude, position.coords.longitude
    map.panTo currentPosition
    loadPlaces map # sometimes will not show

  marker = new qq.maps.Marker
    position: map.getCenter()
    map: map
    draggable: true
    visible: false
    animation: qq.maps.MarkerAnimation.BOUNCE

  $("#new-place").click () ->
    $("#action-add-place").show()
    $("#action-new-place").hide()
    marker.setPosition map.getCenter()
    marker.setVisible true
    false

  $("#add-place").click () ->
    position =  marker.getPosition()
    window.location = "/places/new?latitude=" + position.lat + "&longitude=" + position.lng

  $("#cancel").click () ->
    $("#action-add-place").hide()
    $("#action-new-place").show()
    marker.setVisible false
    false

    # marker.setDraggable(true);
  qq.maps.event.addListener map, "dragend", mapListener
  qq.maps.event.addListener map, "zoom_changed", mapListener
  qq.maps.event.addListener map, "click", (e) ->
    marker.setPosition e.latLng

mapListener = (e) ->
  loadPlaces e.target

loadPlaces = (map) ->
  bounds = map.getBounds()
  $.ajax(
    url: "/places.json"
    data:
      minLat: bounds.lat.minY
      minLng: bounds.lng.minX
      maxLat: bounds.lat.maxY
      maxLng: bounds.lng.maxX
  ).done((data) ->
    drawPlaces data, map
  ).fail((error) ->
    console.log error
  )

drawPlaces = (data, map) ->
  # data = [{id , mood, location{lat,lon}}, ...]
  clearPlaces map
  for place in data
    circle = new qq.maps.Marker
      position: new qq.maps.LatLng place.location.lat, place.location.lon # lon is for lng, sorry
      visible: true
      map: map
    map.places.push circle
    qq.maps.event.addListener circle, 'click', (e) ->
      window.location = "/places/" + place.id

clearPlaces = (map) ->
  if map.places
    for place in map.places
      place.setMap null
  map.places = []
