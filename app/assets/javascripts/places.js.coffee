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
	p_info = new qq.maps.InfoWindow
		map: map
		content: ""
		zIndex: 10
	map.info = p_info
	qq.maps.event.addListener(map, "dragend", mapListener)
)

<script>
	function init() {
		//make dianping position defalut
		var dpLatlng = new qq.maps.LatLng(31.215240, 121.420290);
		var myOptions = {
			zoom: 13,
			center: dpLatlng,
			mapTypeId: qq.maps.MapTypeId.ROADMAP
		};
		var map = new qq.maps.Map(document.getElementById("container"), myOptions);
		var window = new qq.maps.InfoWindow({
			map: map,
			content: "",
			position: map.getCenter(),
			zIndex: 10
		});
		map.window = window;
//            var marker = new qq.maps.Marker({
//                position: myLatlng,
//                map: map
//            });
//            marker.setDraggable(true);

		qq.maps.event.addListener(map, "dragend", mapListener);
		qq.maps.event.addListener(map, "zoom_changed", mapListener);
//            qq.maps.event.addListener(map, 'click', function (e) {
//                marker.setPosition(e.latLng);
//            });
	}

	function loadScript() {
		var script = document.createElement("script");
		script.type = "text/javascript";
		script.src = "http://map.qq.com/api/js?v=2.exp&callback=init";
		document.body.appendChild(script);
	}

	function mapListener(e) {
		var map = e.target;
		var pixel = e.pixel;
		var lat = e.latLng;
		//TODO send backend ,map scope
		console.log(map.getBounds());
//            $.ajax({
//                        url: "",
//                        data: map.getBounds(),
//                    }
//                            .done(function (data) {
							//call the fillPOIs
//
//                            }))
//                    .fail(function (data) {
//
//                    });
		fillPOI({},map);

	}
	function fillPOI(data, map) {
		//data = [{id , mood, location{lat,lon}}, ...]
		//TODO for each data
		var circle = new qq.maps.Circle({
			center: map.getCenter(),
			visible: true,
			radius: 50,
			strokeWeight: 4,
			fillColor: "#00f",
			map: map
		});
		qq.maps.event.addListener(circle, 'click', function (e) {
			var info = map.window;
			info.setPosition(e.latLng);
			info.setContent("My location is " + e.latLng);
			info.open();
		});
	}
	window.onload = loadScript;
</script>
