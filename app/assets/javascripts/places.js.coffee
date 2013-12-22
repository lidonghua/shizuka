# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  # make dianping position defalut
  # dpLatlng = new qq.maps.LatLng 31.215240, 121.420290
  currentPosition = new qq.maps.LatLng 31.215240, 121.420290
  map = new qq.maps.Map document.getElementById 'map-container'
  map.panTo currentPosition
  map.setZoom 15
  navigator.geolocation.getCurrentPosition (position) ->
    currentPosition = new qq.maps.LatLng position.coords.latitude, position.coords.longitude
    map.panTo currentPosition
  # new qq.maps.Marker
  #   position: currentPosition
  #   map: map

  # TODO move following code to add place page
  p_info = new qq.maps.InfoWindow
    map: map
    content: ""
    zIndex: 10
  map.info = p_info # map.window = p_info
  marker = new qq.maps.Marker
    position: currentPosition
    map: map
    draggable: true
    # marker.setDraggable(true);
  qq.maps.event.addListener map, "dragend", mapListener
  qq.maps.event.addListener map, "zoom_changed", mapListener
  qq.maps.event.addListener map, "click", (e) ->
    marker.setPosition e.latLng

# function loadScript() {
#   var script = document.createElement("script");
#   script.type = "text/javascript";
#   script.src = "http://map.qq.com/api/js?v=2.exp&callback=init";
#   document.body.appendChild(script);
# }

mapListener = (e) ->
  map = e.target
  position = e.latLng
  $.ajax(
    url: "/places.json"
  ).done((data) ->
    drawPlaces data, map
  ).fail((error) ->
    console.log error
  )

drawPlaces = (data, map) ->
  # data = [{id , mood, location{lat,lon}}, ...]
  for place in data
    circle = new qq.maps.Circle
      center: new qq.maps.LatLng place.location.lat, place.location.lon # lon is for lng, sorry
      visible: true
      radius: 50
      strokeWeight: 1
      fillColor: "#11e"
      map: map
    qq.maps.event.addListener circle, 'click', (e) ->
      info = map.window
      info.setPosition e.latLng
      info.setContent "My location is " + e.latLng
      info.open()
