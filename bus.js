var markersArray = [];

      function initMap() {
       
        var test = 1;
        BUSNUM = 1;

      
      
      var origin = document.getElementById('end').value;
      var destination = document.getElementById('start').value;
      
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
      
       

        var directionsService = new google.maps.DirectionsService;
        
        var directionsDisplay = new google.maps.DirectionsRenderer({ markerOptions: markerOption });


        
        

        directionsDisplay.setMap(map);

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


        var image = {
     
            url: 'https://thomasbuiltbuses.com/content/uploads/2017/02/2.1hero.jpg',
            size: new google.maps.Size(71, 71),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(17, 34),
            scaledSize: new google.maps.Size(25, 25)
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
          icon: image
        });

      markersArray.push(User);
      markersArray.push(Bus);
        
        var geocoder = new google.maps.Geocoder;

        var service = new google.maps.DistanceMatrixService;
        service.getDistanceMatrix({
          origins: [origin],
          destinations: [destination],
          travelMode: 'DRIVING',
          unitSystem: google.maps.UnitSystem.METRIC,
          avoidHighways: false,
          avoidTolls: false
        }, function(response, status) {
          if (status !== 'OK') {
            alert('Error was: ' + status);
          } else {
         
            var originList = response.originAddresses;
            var destinationList = response.destinationAddresses;
            var outputDiv = document.getElementById('output');
            outputDiv.innerHTML = '';
            


            var showGeocodedAddressOnMap = function(asDestination) {
              var icon = asDestination ? destinationIcon : originIcon;
              return function(results, status) {
                if (status === 'OK') {
                    map.fitBounds(bounds.extend(results[0].geometry.location));
                  /**markersArray.pop();
                  markersArray.push(new google.maps.Marker({
                    map: map,
                    position: results[0].geometry.location,
                    icon: icon
                  }));*/

                } else {
                  alert('Geocode was not successful due to: ' + status);
                }
              };
            };

            
            
            for (var i = 0; i < originList.length; i++) {
              var results = response.rows[i].elements;
              geocoder.geocode({'address': originList[i]},
                  showGeocodedAddressOnMap(false));
              for (var j = 0; j < results.length; j++) {
                geocoder.geocode({'address': destinationList[j]},
                    showGeocodedAddressOnMap(true));
                outputDiv.innerHTML += originList[i] + ' to ' + destinationList[j] +
                    ': ' + results[j].distance.text + ' in ' +
                    results[j].duration.text + '<br>';
              }
            }
          }
        })






        directionsService.route({
          origin: origin,
          destination: destination,
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