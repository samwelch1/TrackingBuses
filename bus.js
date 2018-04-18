var markersArray = [];

      function initMap() {
       
        var BUSNUM = 1;
  
      
      var origin = document.getElementById('end').value;
      
      var la = parseFloat(origin.substring(0,6));
      var ln = parseFloat(origin.substring(7));
      var map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: la, lng: ln},
          zoom: 10, mapTypeId: 'roadmap'
        });

      
        var nothing = {

          url:'https://ihg.scene7.com/is/image/ihg/transparent_1440?fmt=png-alpha&wid=1024&hei=768',
          size: new google.maps.Size(71, 71),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(17, 34),
          scaledSize: new google.maps.Size(25, 25)

        };
      
    
      var markerOption = {
                    clickable: false,
                    flat: true,
                    icon: nothing,
                    visible: true,
                    map: map
                };
      
       

        var directionsService = new google.maps.DirectionsService();

        
        var directionsDisplay = new google.maps.DirectionsRenderer({ markerOptions: markerOption });


        
        

        directionsDisplay.setMap(map);
        directionsDisplay.setPanel(document.getElementById('floating-panel2'));

         var control = document.getElementById('floating-panel');
        control.style.display = 'block';
        map.controls[google.maps.ControlPosition.TOP_CENTER].push(control);

        var onChangeHandler = function() {
          calculateAndDisplayRoute(directionsService, directionsDisplay, map);
        };
        document.getElementById('start').addEventListener('change', onChangeHandler);
        document.getElementById('end').addEventListener('change', onChangeHandler);
 
      }

      function calculateAndDisplayRoute(directionsService, directionsDisplay, map) {


        var bounds = new google.maps.LatLngBounds;
        
        
        var origin = document.getElementById('end').value;
        var destination = document.getElementById('start').value;


        var bus = {
     
            url: 'https://thomasbuiltbuses.com/content/uploads/2017/02/2.1hero.jpg',
            size: new google.maps.Size(100, 100),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(17, 34),
            scaledSize: new google.maps.Size(100, 100)
          };


       var person = {

          url:'https://d30y9cdsu7xlg0.cloudfront.net/png/8205-200.png',
          size: new google.maps.Size(71, 71),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(17, 34),
          scaledSize: new google.maps.Size(25, 25)

        };
       
       var nothing = {

          url:'https://ihg.scene7.com/is/image/ihg/transparent_1440?fmt=png-alpha&wid=1024&hei=768',
          size: new google.maps.Size(71, 71),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(17, 34),
          scaledSize: new google.maps.Size(25, 25)

        };

  
        
       var destinationIcon = nothing;
       var originIcon = nothing;

        

       var la = parseFloat(origin.substring(0,6));
       var ln = parseFloat(origin.substring(7));
       var laD = parseFloat(destination.substring(0,6));
       var lnD = parseFloat(destination.substring(7));

        

       deleteMarkers(markersArray);
       

       var User = new google.maps.Marker({
          position: {lat: la, lng:ln},
          map: map,
          icon: person
        });

       var Bus = new google.maps.Marker({
          position: {lat: laD, lng:lnD},
          map: map,
          icon: bus
        });

      markersArray.push(User);
      markersArray.push(Bus);
        
        
      

        directionsService.route({
          origin: destination,
          destination: origin,
          travelMode: 'DRIVING'
        }, function(response, status) {
          if (status === 'OK') {
            directionsDisplay.setDirections(response);
            

          } else {
            window.alert('Directions request failed due to ' + status);
          }
        });

        
      }

      function deleteMarkers(markersArray) {
        clearMarkers();
        for (var i = 0; i < markersArray.length; i++) {
          markersArray[i].setMap(null);
        }
        markersArray = [];
         console.log("ay");
      }

      function clearMarkers() {
        setMapOnAll(null);
      }

      function setMapOnAll(map) {
        for (var i = 0; i < markersArray.length; i++) {
          markersArray[i].setMap(map);
        }
      }