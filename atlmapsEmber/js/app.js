var App = Ember.Application.create({
    LOG_TRANSITIONS: true
});

App.Router.map(function() {
    this.resource('projects', function() {
        this.resource('project', { path: '/:project_id' });
    });

});

var layersStore = Ember.Object.create({
  loaded: []
});

// Controllers

App.ProjectsIndexController = Ember.ArrayController.extend({
    sortProperties: ['name'],
    
    //newProject: '',
    
    actions : {
        
        createProject: function() {
            
            time = (new Date()).toTimeString();
            
            var project = this.store.createRecord('project', {
                name: time,
            });
            
            var self = this;
            
            var onSuccess = function(project) {
                
                var newProject = DS.PromiseObject.create({
                    promise: App.Project.store.fetch('project', { name: time })
                });
    
                newProject.then(function() {
                    console.log(newProject)
                    self.transitionToRoute('project', newProject.get('content.content.0.id'));
                });
            };
            project.save().then(onSuccess);

        },
        
        //saveProject: function() {
        //    console.log(this.get('newProject'));
        //    var project = this.store.createRecord('project', {
        //        name: this.get('newProject'),
        //        status: 'UNSAVED'
        //    });
        //    project.save();
        //    
        //},
        
        deleteProject: function(project) {
            console.log(project);
            this.store.find('project', project).then(function (project) {
                project.destroyRecord();
            });
            
        }
    }
    
});

App.ProjectController = Ember.ObjectController.extend({
    showLayers: function() {
      
      var layers = this.get("model.layer_ids.content.content")
      var added_layers = [];
      $(layers).each(function(){
        added_layers.push(this.id)
      })
      layersStore.set("loaded",added_layers)
      
      return this.get('model.layer_ids')
      
    }.property('model.layer_ids.@each'),
    
    // Empty property for the input filed so we can clear it later.
    projectName: '',
    
    thisProject: function() {}.property(),
    
    getLayers: function(){
        loaded_layers = this.get("model.layer_ids").content.content.length;
        var i = this.incrementProperty('i'),
            c = loadCount.get("count");
        
        if(i !== c ){
          this.get("model").reload();
        }
      
        loadCount.set("count",i);

    }.property("model"),
    
    savedStatus: function() {
        //console.log(this);
    }.property(),
    
    actions: {
        reload: function() {
          this.get('model').reload().then(function(model) {
            // do something with the reloaded model
            console.log(model.layer_ids);
          });
        },
      
        updateProject: function() {
            var project = this.get('model')
            project.set('name', this.get('projectName'))
            project.set('saved', true);
            
            // perserve this so we can clear the projectName field after save.
            var controller = this;
            project.save().then(function(project){
                // Clear the projectName filed.
                controller.set('projectName', '');    
            });
        },
    }
});

App.AddLayerModalController = Ember.ArrayController.extend({
   sortProperties: ['layer_type', 'name'],
});

// Routers

App.IndexRoute = Ember.Route.extend({});

App.AddLayerModalRoute = Ember.Route.extend({
    model: function() {
        // return this.store.find('layer');
    },
});

App.ProjectsIndexRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('project');
    },
    
})

App.ProjectRoute = Ember.Route.extend({
    
    model: function(params) {
        var project = this.store.find('project',  params.project_id);
        return project;
    },

    actions: {
        addLayer: function(layer, model) {
            var layerID = layer.get('id');
            var _this = this;
            var projectID = _this.get('controller.model.id');            
            var projectlayer = this.store.createRecord('projectlayer', {
                project_id: projectID,
                layer_id: layerID
            });
            projectlayer.save().then(function(){
              _this.get("controller.model").reload();
            });
        },
        
        removeLayer: function(layer, project) {
            var layerID = layer.get('id');
            var layerClass = layer.get('layer');
            var _this = this;
            var project = project || this.get("controller.model.id");

            var projectLayer = DS.PromiseObject.create({
                promise: this.store.find('projectlayer', { layer_id: layerID, project_id: project })
            });

            projectLayer.then(function() {
                var projectLayerID = projectLayer.get('content.content.0.id');
                    console.log(projectLayer);
                
                App.Projectlayer.store.find('projectlayer', projectLayerID).then(function(projectlayer){
                    projectlayer.destroyRecord().then(function(){
                        _this.get("controller.model").reload();
                    });
                });

            });
            
            $("."+layerClass).fadeOut( 500, function() {
                $(this).remove();
            });

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
    
});

var loadCount = Ember.Object.create({
  count: 0
});


App.Map = Ember.Object.extend();
var store = App.Map.create();

// Views

// Components

App.BaseMapComponent = Ember.Component.extend({
    didInsertElement: function() {
        
        var map = L.map('map', {
            center: [33.7489954,-84.3879824],
            zoom: 14,
            zoomControl:false 
        });
        
        var osm = L.tileLayer('http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors Georgia State University and Emory University',
        }).addTo(map).setZIndex(0);
        
        var MapQuestOpen_Aerial = L.tileLayer('http://oatile{s}.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg', {
            attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency contributors Georgia State University and Emory University',
            subdomains: '1234'
        });
        
        var toner = L.tileLayer('http://d.tile.stamen.com/toner/{z}/{x}/{y}.png', {
          attribution: '&copy; <a href="http://osm.org/copyright">Stamen Toner Map</a> contributors Georgia State University and Emory University',
        });
                
        var baseMaps = {
            "Street": osm,
            "Satellite": MapQuestOpen_Aerial,
            "Toner": toner
        };        
        
        L.control.zoom({ position: 'topright' }).addTo(map);
        L.control.layers(baseMaps).addTo(map);

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
                    // console.log(layerName)
                    var slider = $("input.slider, input ."+layerName).slider({
                        //precision: 2,
                        value: 10,
                        reversed: true
                    });
        
                });
    }.property(),
    
    actions: {
        opacityChange: function() {
            var layerName = this.layer
            // console.log("opacity layer name:"+layerName)
            var value = $("input."+layerName).val();
            //if(isNaN(value)) {
            //    var value = $("input."+layerName).val();
            //}
            // console.log("value of opacity slider:"+value)
            var opacity = value / 10;
            // console.log("opacity:"+opacity);
            $("div."+layerName+",img."+layerName).css({'opacity': opacity});
        }
    }
});

App.AddRemoveLayerButtonComponent = Ember.Component.extend({
    layerAdded: function(layer){
      return false
    }.property(),
    actions: {
        buttonAddLayer: function(layer) {
          this.toggleProperty("layerAdded");
          this.set('action','addLayer');
          this.sendAction('action', this.get('param'));
        },
        buttonRemoveLayer: function(layer) {
          this.toggleProperty("layerAdded")
          this.set('action','removeLayer');
          this.sendAction('action', this.get('param'));
        },
    }
});

Ember.Handlebars.helper('is_active', function(layer) {
    var loaded_layers = layersStore.get("loaded"),
        this_layer = this.get("param.id");
        
    if (loaded_layers.indexOf(this_layer) > -1){
      this.set("layerAdded",true)
      return
    }
    this.set("layerAdded",false)
    return
});

App.RemoveLayerButtonComponent = Ember.Component.extend({
    actions: {
        removeLayer: function() {
            this.sendAction('action', this.get('param'));
        }
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
        });
        
        mappedLayer.then(function() {
            
            var slug = mappedLayer.get('layer');
            var map = store.get('map');
            
            instution = mappedLayer.get('institution');
            
            switch(mappedLayer.get('layer_type')) {
                case 'planningatlanta':

                    var tile = L.tileLayer('http://static.library.gsu.edu/ATLmaps/tiles/' + mappedLayer.get('layer') + '/{z}/{x}/{y}.png', {
                        layer: mappedLayer.get('layer'),
                        tms: true,
                        minZoom: 13,
                        maxZoom: 19,
                        //attribution: 'GSU'
                    }).addTo(map).bringToFront().getContainer();
                                        
                    $(tile).addClass(slug);

                    break;
                
                case 'wms':
                
                    var wmsLayer = L.tileLayer.wms(instution.geoserver + mappedLayer.get('url') + '/wms', {
                        layers: mappedLayer.get('url')+':'+mappedLayer.get('layer'),
                        format: 'image/png',
                        CRS: 'EPSG:900913',
                        transparent: true
                    }).addTo(map).bringToFront().getContainer();
                                        
                    $(wmsLayer).addClass(slug);
                
                    break;
                
                case 'geojson':
                    var slug = mappedLayer.get('layer')
                    function viewData(feature, layer) {
                        var popupContent = "<h2>"+feature.properties.name+"</h2>"+
                        "<p>"+feature.properties.description+"</p>"+
                        "<img class='geojson' src='"+feature.properties.image.url+"' title='"+feature.properties.image.name+"' />"+
                        "<span>Photo Credit: "+feature.properties.image.credit+"</span>";
                        layer.bindPopup(popupContent);
                        
                    }
                    function setIcon(url, class_name){
                      return iconObj = L.icon({
                                            iconUrl: url,
                                            //iconSize: [50, 65],
                                            iconAnchor: [16, 37],
                                            popupAnchor: [0, -28],
                                            className: class_name
                                          });
                    }
                    
                    if(mappedLayer.get('url')){
                      var points = new L.GeoJSON.AJAX(mappedLayer.get('url'), {
                          pointToLayer: function (feature, latlng) {
                            // console.log("slug",slug);
                            var marker = L.marker(latlng, {icon: setIcon("images/marker2.png", slug)});
                            return marker
                          },
                          onEachFeature: viewData,
                      }).addTo(map);
                      break;
                    }
            }
            
            shuffle.init();
        });
        //return mappedLayer
    }.property(),
    
    actions: {
        
    }
});

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
    project_ids: DS.hasMany('project', {async: true}),
    institution: DS.attr()
});

App.Project = DS.Model.extend({
    name: DS.attr('string'),
    description: DS.attr('string'),
    saved: DS.attr('boolean'),
    published: DS.attr('boolean'),
    //user: DS.attr('number'),
    layer_ids: DS.hasMany('layer', {async: true}),
})

App.Projectlayer = DS.Model.extend({
    layer_id: DS.attr(),
    project_id: DS.attr()
});

$(document).ready(function(){
  $.material.ripples(".btn, .navbar a");
  (function(){
  // init on shuffle items 
    shuffle.init();
  })()
  
  // document events
  $(document).on('click','#hide-layer-options',function(){
    $(".layer-controls").animate({"left":"-100%"},500,"easeInQuint",function(){
      $("#show-layer-options").fadeIn(500);
    });
  })
  .on('click','#show-layer-options',function(){
    $(".layer-controls").animate({"left":"0%"},500,"easeOutQuint");
    $("#show-layer-options").fadeOut(500);
  })
  .on('click','.shuffle-items li.item',function(){
    shuffle.click(this);
  })
  
})
