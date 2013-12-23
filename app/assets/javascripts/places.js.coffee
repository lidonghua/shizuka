# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  currentPosition = new qq.maps.LatLng 31.215240, 121.420290 # DianPing
  mapContainer = document.getElementById 'map-container'
  unless mapContainer
    return
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

  p_info = new qq.maps.InfoWindow
    map: map
    content: ""
    zIndex: 10
  map.info = p_info # map.window = p_info

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
    circle = new qq.maps.Circle
      center: new qq.maps.LatLng place.location.lat, place.location.lon # lon is for lng, sorry
      visible: true
      radius: 50
      strokeWeight: 0
      fillColor: "#11e"
      map: map
    map.places.push circle
    qq.maps.event.addListener circle, 'click', (e) ->
      info = map.window
      info.setPosition e.latLng
      info.setContent "My location is " + e.latLng
      info.open()

clearPlaces = (map) ->
  if map.places
    for place in map.places
      place.setMap null
  map.places = []
