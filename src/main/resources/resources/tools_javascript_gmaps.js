var gmaps = {
    
    options: {
        latSelector: null,
        lngSelector: null,
        defaultLat: 50.118440385022076,
        defaultLng: 8.631230592727661,
        zoom: {
            _default: 1,
            search: 10,
            detail: 14,
            country: 5
        },
        cultureName: 'de-DE',
        baseCountryCode: 'de',
        countryName: 'Deutschland',
		geoCoordinatesFormat: {
			format: '#0.0000000',
			groupingSeparator: '',
			decimalSeparator: '.'
		}
    },
    
    map: null,
    geocoder: new google.maps.Geocoder(),
    
    markerNumber: 0,
    currentMarker: null,
    currentInfoWindow: null,
    
    init: function(options){

      var self = this;
      this.options = jQuery.extend(this.options, options);
      
      var currentGeoData = this.getGeoDataFromForm();
      if (currentGeoData == null) return;
      
      var isGeoDataValid = true;  
      if (isNaN(currentGeoData.lat) || isNaN(currentGeoData.lng)) {
        isGeoDataValid = false;
        currentGeoData.lat = this.options.defaultLat;
        currentGeoData.lng = this.options.defaultLng;
        currentGeoData.zoom =  this.options.zoom._default;
      }
      
      var myOptions = {
        zoom: currentGeoData.zoom,
        center: new google.maps.LatLng(currentGeoData.lat, currentGeoData.lng),
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };

      this.map = new google.maps.Map(jQuery("#map_canvas").get(0), myOptions);
      
      if (this.map) {
      
        if (isGeoDataValid) {
            this.addMarker(new google.maps.LatLng(currentGeoData.lat, currentGeoData.lng));
        } else {
            this.showLocation(this.options.countryName, this.options.zoom.country);
        }
      
        google.maps.event.addListener(this.map, 'rightclick', function(event) {
            if (self.markerNumber == 0) {
                self.addMarker(event.latLng);
            }
        });
        
        //Form fields events
        jQuery(this.options.latSelector).bind('change', function(){self.refreshMarkerPosition();});
        jQuery(this.options.lngSelector).bind('change', function(){self.refreshMarkerPosition();});
        
      }
      
    },
    
    getGeoDataFromForm: function(){
        if ((jQuery(this.options.latSelector).length == 0) || (jQuery(this.options.lngSelector).length == 0)) return null;
        else { 
			$.format.locale({
				number: this.options.geoCoordinatesFormat
			});
			return {
				lat: parseFloat($.format.number(jQuery(this.options.latSelector).attr('value'))),
				lng: parseFloat($.format.number(jQuery(this.options.lngSelector).attr('value'))),
				zoom: this.options.zoom.detail
			};
		}
    },

    addMarker: function(location){
      var pm = this.placeMarker(location);
      this.currentMarker = pm.marker;
      this.currentInfoWindow = pm.infowindow;    
    },
        
    placeMarker: function(location) {
    
        var self = this;
        
        this.markerNumber++;
        var markerID = 'marker-'+this.markerNumber;
        
        //create and add marker
        var marker = new google.maps.Marker({
            position: location, 
            map: this.map,
            draggable: true
        });
        
        //set form fields
        self.setFormFields(marker);
        
        //create infowindow
        var infowindow = new google.maps.InfoWindow({ 
            content: '<b>Lat:</b> '+location.lat()+'<br/><b>Lng:</b> '+location.lng()+'<br/><br/><a id="'+markerID+'"  href="javascript: void(0)">Delete marker</a><br/><a id="'+markerID+'_refresh"  href="javascript: void(0)">Refresh data</a><br/><br/>',
            maxWidth: 200
        });
        
        //Events
        google.maps.event.addListener(marker, 'click', function() {
            infowindow.open(self.map, marker);
        });

        google.maps.event.addListener(marker, 'dragend', function() {
            infowindow.setOptions({
                content: '<b>Lat:</b> '+marker.getPosition().lat()+'<br/><b>Lng:</b> '+marker.getPosition().lng()+'<br/><br/><a id="'+markerID+'"  href="javascript: void(0)">Delete marker</a><br/><a id="'+markerID+'_refresh"  href="javascript: void(0)">Refresh data</a><br/><br/>'
            });
            self.setFormFields(marker);
        });

        google.maps.event.addListener(infowindow, 'domready', function() {
            //Delete marker event
            jQuery('a#'+markerID).bind('click', function(){
                self.removeMarker(marker, infowindow);
                marker = null;
                infowindow = null;
            });
            //Refresh data
            jQuery('a#'+markerID+'_refresh').bind('click', function(){
                self.setFormFields(marker);
            });
            
        });
        
        return {marker: marker, infowindow: infowindow};
        
    },
    
    removeMarker: function(marker, infowindow){
        if (infowindow != null) window.setTimeout(function(){infowindow.close();}, 50);
        marker.setMap(null);
        this.clearFormFields();
        this.markerNumber--;
    },
    
    clearFormFields: function(){
        jQuery(this.options.latSelector).attr('value', '');
        jQuery(this.options.lngSelector).attr('value', '');
    },
    
    setFormFields: function(marker){
	
		$.format.locale({
			number: this.options.geoCoordinatesFormat
		});

        jQuery(this.options.latSelector).attr('value', $.format.number(marker.getPosition().lat(), this.options.geoCoordinatesFormat.format));
        jQuery(this.options.lngSelector).attr('value', $.format.number(marker.getPosition().lng(), this.options.geoCoordinatesFormat.format));
    },
    
    refreshMarkerPosition: function(){
        
        var self = this;
        
        if (isNaN(parseFloat(jQuery(this.options.latSelector).attr('value'))) || isNaN(parseFloat(jQuery(this.options.lngSelector).attr('value')))) return;
        
        var latLng = new google.maps.LatLng(jQuery(this.options.latSelector).attr('value'),jQuery(this.options.lngSelector).attr('value'));
        this.currentMarker.setPosition(latLng);
        this.map.setCenter(latLng);
         
        var markerID = 'marker-'+this.markerNumber;;
        if (this.currentInfoWindow != null) {
            this.currentInfoWindow.setOptions({
                content: '<b>Lat:</b> '+this.currentMarker.getPosition().lat()+'<br/><b>Lng:</b> '+this.currentMarker.getPosition().lng()+'<br/><br/><a id="'+markerID+'"  href="javascript: void(0)">Delete marker</a><br/><a id="'+markerID+'_refresh"  href="javascript: void(0)">Refresh data</a><br/><br/>'
            });
            window.setTimeout(function(){self.currentInfoWindow.close();}, 50);
        }
    },
    
    showLocation: function(address, zoom) {
        var self = this;
        if (address == 'Search location ...') return false;
        this.geocoder.geocode({address: address, language: this.options.baseCountryCode, region: this.options.cultureName}, function(result, status){
            if (status == google.maps.GeocoderStatus.OK) {
                self.map.setCenter(result[0].geometry.location);
                zoom = (!zoom) ? self.options.zoom.search : zoom ;
                self.map.setZoom(zoom);
                
                if (self.currentMarker == null) self.addMarker(result[0].geometry.location);
                
            } else alert('Not found !');
        });
        return false;
    },
    
    goToMarker: function(){
        if (typeof(this.currentMarker) == 'object') {
            this.map.setCenter(this.currentMarker.getPosition());
        }
    },
    
    deleteMarker: function(){
        this.removeMarker(this.currentMarker, this.currentInfoWindow);
        this.currentMarker = null;
        this.currentInfoWindow = null;
    }

};