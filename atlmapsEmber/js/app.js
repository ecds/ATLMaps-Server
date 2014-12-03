var App = Ember.Application.create({
    LOG_TRANSITIONS: true
});

App.Router.map(function() {
    //this.resource('layers');
    this.resource('createMap');

});

// Controllers

App.IndexController = Ember.ArrayController.extend({
    logo: src="https://pbs.twimg.com/profile_images/378800000044814200/04835e4d7c58d4b305b1769c20160b31_400x400.jpeg",
});

App.CreateMapController = Ember.ArrayController.extend({
    sortProperties: ['layer_type', 'name'],
    
});

// Routers

App.IndexRoute = Ember.Route.extend({

});

App.CreateMapRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('layer');
    },
    
    
    actions: {
        addLayer: function(layer) {
            var slug = layer.get('layer')
            if ($("."+slug).length!==1){
                var map = store.get('map');
                var tile = L.tileLayer('http://static.library.gsu.edu/ATLmaps/tiles/' + layer.get('layer') + '/{z}/{x}/{y}.png', {
                    layer: layer.get('layer'),
                    tms: true,
                    minZoom: 13,
                    maxZoom: 19,
                    //attribution: 'GSU'
                }).addTo(map).getContainer();
                
                $(tile).addClass(slug)
            }
            else{
                $("."+slug).fadeOut( 2000, function() {
                    $("."+slug).remove();
                });
            }
            
        }
    }
});


App.Map = Ember.Object.extend();
var store = App.Map.create();

// Views

App.CreateMapView = Ember.View.extend({

    didInsertElement: function() {
        var map = L.map('map').setView([33.7489954,-84.3879824], 15);
        L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
        }).addTo(map);

        store.set('map', map);
        // save map instance
        this.controller.set('map', map);
        
    },
    

});

App.AddLayerView = Ember.View.extend({
    
    click: function(evt) {
        //this.get('controller').send('addLayer', 'some map')
        
        var map = store.get('map');
        console.log(map)
        var wmsLayer = L.tileLayer.wms("http://geospatial.library.emory.edu:8081/geoserver/ebola/wms", {
            layers: 'ebola:ATL28',
            format: 'image/png',
            CRS: 'EPSG:900913',
            transparent: true,
            auth: 'admin:geospatialisthefuture',
            //attribution: 'Emory'
          });
          wmsLayer.addTo(map);
        
        
    }
});

// Components

App.AddRemoveLayerButtonComponent = Ember.Component.extend({
    actions: {
        buttonAdd: function() {
            this.toggleProperty('layerAdded');
            this.sendAction('action', this.get('param'));
        },
        buttonRemove: function() {
            this.toggleProperty('layerAdded');
            this.sendAction('action', this.get('param'));
        }
    }
});


// Adapter


App.ApplicationAdapter = DS.RESTAdapter.extend({
    host: 'http://api.atlmaps-dev.com:3000',
    namespace: 'v1',
    suffix: '.json',
    pathForType: function(type) {
        return this._super(type) + this.get('suffix');
    }
});


// Models
App.Layer = DS.Model.extend({
    collection: DS.attr('number'),
    name: DS.attr('string'),
    layer_type: DS.attr('string'),
    isNew: DS.attr('boolean')
});

App.Layer = DS.Model.extend({
    name: DS.attr('string'),
    slug: DS.attr('string'),
    keywords: DS.attr('string'),
    description: DS.attr('string'),
    url: DS.attr('string'),
    layer: DS.attr('string'),
    date: DS.attr('date'),
    layer_type: DS.attr('string'),
    zoomlevels: DS.attr('string'),
    minx: DS.attr('number'),
    miny: DS.attr('number'),
    maxx: DS.attr('number'),
    maxy: DS.attr('number'),
});

