var App = Ember.Application.create({
    LOG_TRANSITIONS: true
});

App.Router.map(function() {
    //this.resource('layers');
    this.resource('createMap');
    this.resource('projects');
    this.resource('project', { path: 'project/:project_id' });

});

// Controllers

App.CreateMapController = Ember.ArrayController.extend({
    sortProperties: ['layer_type', 'name'],
    
    actions : {
        
        createProject: function() {
            var project = this.store.createRecord('project', {
                name: (new Date()).toTimeString(),
                status: 'UNSAVED'
            });
            project.save()
        }
    }
    
});

App.ProjeclayerController = Ember.ObjectController.extend({
    actions: {
        addNewLayer: function() {
            console.log(params.foo)
        }
    }
});

App.AddLayerModalController = Ember.ArrayController.extend({
   sortProperties: ['layer_type', 'name'],
});

// Routers

App.IndexRoute = Ember.Route.extend({});

App.AddLayerModalRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('layer');
    },
});

App.ProjectsRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('project');
    },
})

App.ProjectRoute = Ember.Route.extend({
    model: function(params) {
        var project = this.store.find('project',  params.project_id);
        return project;
    },
    
    layers: function() {
        return this.store.find('layer');
    },//.property('@each.layer'),
    
    actions: {
        addLayer: function(layer, model) {
            var layerID = layer.get('id');
            var projectID = this.get('controller.id');
            console.log(projectID, layerID)

            var projectlayer = this.store.createRecord('projectlayer', {
                project_id: projectID,
                layer_id: layerID
            });
            projectlayer.save();
            
        },
        
        // Modal
        showModal: function(name) {
            var content = this.store.find('layer');
            this.controllerFor(name).set('content', content);
            this.render(name, {
                into: 'application',
                outlet: 'modal'
            });
        },
        removeModal: function() {
            this.disconnectOutlet({
                outlet: 'modal',
                parentView: 'application'
            });
        }
    },
    
    didInsertElement: function() {
        $('#ex1').slider({
            formatter: function(value) {
                return 'Current value: ' + value;
            }
        });
    }
    
});

App.CreateMapRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('layer');
    },
    
    actions: {
        addLayer: function(layer) {
            var slug = layer.get('layer');
            if ($("."+slug).length!==1){
                var map = store.get('map');
                var tile = L.tileLayer('http://static.library.gsu.edu/ATLmaps/tiles/' + layer.get('layer') + '/{z}/{x}/{y}.png', {
                    layer: layer.get('layer'),
                    tms: true,
                    minZoom: 13,
                    maxZoom: 19,
                    //attribution: 'GSU'
                }).addTo(map).getContainer();
                
                $(tile).addClass(slug);
            }
            else{
                $("."+slug).fadeOut( 500, function() {
                    $(this).remove();
                });
            }
            
        },
        
        // Modal
        showModal: function(name, content) {
            console.log(content)
            this.controllerFor(name).set('content', content);
            this.render(name, {
                into: 'application',
                outlet: 'modal'
            });
        },
        removeModal: function() {
            this.disconnectOutlet({
                outlet: 'modal',
                parentView: 'application'
            });
        }
        
    }
});


App.Map = Ember.Object.extend();
var store = App.Map.create();

// Views

// Components

App.BaseMapComponent = Ember.Component.extend({
    didInsertElement: function() {
        var map = L.map('map', {zoomControl:false}).setView([33.7489954,-84.3879824], 14);
        L.control.zoom({ position: 'topright' }).addTo(map);
        L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
        }).addTo(map);

        store.set('map', map);
        // save map instance
        this.controller.set('map', map);
    },
});


App.OpacitySliderComponent = Ember.Component.extend({
    opacityslider: function() {
        
                var layer = DS.PromiseObject.create({
                    promise: App.Layer.store.find('layer', this.layerID)
                });
                
                layer.then(function() {
                    
                    var layerName = layer.get('layer');
                    console.log(layerName)
                    var slider = $("input.slider, input ."+layerName).slider({
                                //precision: 2,
                                value: 10,
                              });
        
                });
    }.property(),
    
    actions: {
        opacityChange: function() {
            console.log(this.layer);
            var layerName = this.layer
            value = $("input."+layerName).val();
            var opacity = value / 10;
            console.log(opacity);
            $("div."+layerName+",img."+layerName).css({'opacity': opacity});
        }
    }
});

App.AddRemoveLayerButtonComponent = Ember.Component.extend({
    actions: {
        buttonToggle: function() {
            this.toggleProperty('layerAdded');
            console.log(this);
            this.sendAction('action', this.get('param'));
        },
    }
});

App.ListAddedLayersComponent = Ember.Component.extend({
    
    model: function() {
        return this.store.find('project');
    },

});

App.MyModalComponent = Ember.Component.extend({
    actions: {
        ok: function() {
            this.$('.modal').modal('hide');
            this.sendAction('ok');
        }
    },
    show: function() {
        this.$('.modal').modal().on('hidden.bs.modal', function() {
            this.sendAction('close');
        }.bind(this));
    }.on('didInsertElement')
});

App.MapLayersComponent = Ember.Component.extend({
    mappedLayers: function() {
        
        var mappedLayer = DS.PromiseObject.create({
            promise: App.Layer.store.find('layer', this.layerID)
        })
        
        mappedLayer.then(function() {
            
            var slug = mappedLayer.get('layer');
            var map = store.get('map');
            
            switch(mappedLayer.get('layer_type')) {
                case 'planningatlanta':
                    if ($("."+slug).length!==1){
                        var tile = L.tileLayer('http://static.library.gsu.edu/ATLmaps/tiles/' + mappedLayer.get('layer') + '/{z}/{x}/{y}.png', {
                            layer: mappedLayer.get('layer'),
                            tms: true,
                            minZoom: 13,
                            maxZoom: 19,
                            //attribution: 'GSU'
                        }).addTo(map).getContainer();
                        
                        $(tile).addClass(slug);
                    }
                    else{
                        $("."+slug).fadeOut( 500, function() {
                            $(this).remove();
                        });
                    }
                    break;
                
                case 'geojson':
                    var slug = mappedLayer.get('layer')
                    function viewData(feature, layer) {
                        var popupContent = "<h2>"+feature.properties.name+"</h2>";
                        layer.bindPopup(popupContent);
                    }
                    function setIcon(url, class_name){
                      return iconObj = L.icon({
                                            iconUrl: url,
                                            iconSize: [20, 25],
                                            iconAnchor: [16, 37],
                                            popupAnchor: [0, -28],
                                            className: class_name
                                          });
                    }
                    
                    if(mappedLayer.get('url')){
                      console.log(mappedLayer.get('url'));
                      var points = new L.GeoJSON.AJAX(mappedLayer.get('url'), {
                          pointToLayer: function (feature, latlng) {
                            console.log("slug",slug);
                            var marker = L.marker(latlng, {icon: setIcon("images/marker2.png", slug)});
                            return marker
                          },
                          onEachFeature: viewData,
                      }).addTo(map);
                      break;
                    }
            }
        });
        //return mappedLayer
    }.property(),
    
    actions: {
        
    }
})



// Adapter

App.ApplicationAdapter = DS.RESTAdapter.extend({
    host: 'http://api.atlmaps-dev.com:7000',
    namespace: 'v1',
    suffix: '.json',
    buildURL: function(record, suffix) {
      var s = this._super(record, suffix);
      return s + this.get('suffix');
    }
});


App.Store = DS.Store.extend({
  adapter: App.ApplicationAdapter
});


// Models
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
    project_ids: DS.hasMany('project', {async: true})
});

App.Project = DS.Model.extend({
    name: DS.attr('string'),
    description: DS.attr('string'),
    status: DS.attr('string'),
    //user: DS.attr('number'),
    layer_ids: DS.hasMany('layer', {async: true}),
});

App.Projectlayer = DS.Model.extend({
    layer_id: DS.attr(),
    project_id: DS.attr()
});

$(document).ready(function(){
  $.material.ripples(".btn, .navbar a");
  (function(){
  // init on shuffle items 
    var shuffle = {
      set_position: function(){
        var $items = $(".shuffle-items li.item"),
        len = $items.length,
        zIndex = 5;
        $items.each(function(i){
          var z = parseInt( zIndex + parseInt(len) - parseInt(i) );
          $(this).css("z-index", z)
        });
        var offset = $items.not(".collapsed").height()+$(".shuffle-items li.item.collapsed").first().height()-5;
        $(".shuffle-items li.item.collapsed").css("top",offset);
      }
    }
    
    shuffle.set_position();

    var rtime = new Date(1, 1, 2000, 12,00,00);
    var timeout = false;
    var delta = 200;
    $(window).resize(function() {
      rtime = new Date();
      if (timeout === false) {
        timeout = true;
        setTimeout(resizeend, delta);
      }
    });
    
    function resizeend() {
      if (new Date() - rtime < delta) {
        setTimeout(resizeend, delta);
      } else {
        timeout = false;
        shuffle.set_position();
      }               
    }
  })()
  
  // document events
  $(document).on('click','#hide-layer-options',function(){
    $(".card.layer-controls").animate({"left":"-100%"},function(){
      $("#show-layer-options").fadeIn(500);
    });
  })
  .on('click','#show-layer-options',function(){
    $(".card.layer-controls").animate({"left":"0%"});
    $("#show-layer-options").fadeOut(500);
  })
  .on('click','.shuffle-items li.item',function(){
    var $items = $(".shuffle-items li.item"),
        len = $items.length,
        zIndex = 5;
    $items.addClass("collapsed");
    $items.each(function(i){
      var z = parseInt( zIndex + parseInt(len) - parseInt(i) );
      $(this).css("z-index", z)
    });
    $(this).removeClass('collapsed').css("z-index", zIndex + parseInt(len)).css("top",0);
    var offset = $(this).height()+$(".shuffle-items li.item.collapsed").first().height()-5
    $(".shuffle-items li.item.collapsed").css("top",offset);
  })
  
})
