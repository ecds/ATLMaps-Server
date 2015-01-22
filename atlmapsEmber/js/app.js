window.ENV = window.ENV || {};
window.ENV['simple-auth'] = {
    authorizer: 'simple-auth-authorizer:oauth2-bearer',
};

window.ENV['simple-auth-oauth2'] = {
    serverTokenEndpoint: 'http://atlmaps-dev.com:7000/oauth/token',
    serverTokenRevocationEndpoint: 'http://atlmaps-dev.com:7000/oauth/revoke',
};

var App = Ember.Application.create({
    LOG_TRANSITIONS: true
});

App.Router.map(function() {
    this.resource('projects', function() {
        this.resource('project', { path: '/:project_id' });
    });
    this.resource('about');
    this.route('login');
});

// Objects

var layersStore = Ember.Object.create({
  loaded: []
});

var Counts = Ember.Object.create({
    vectorLayer: 0,
    marker: 0
});

App.Map = Ember.Object.extend();
var store = App.Map.create();

//App.ApplicationController = Ember.Controller.extend({});

App.ProjectsIndexController = Ember.ArrayController.extend({
    sortProperties: ['name'],
    
    myProjects: function() {
        //console.log(this.session.get('content.user.id'))
        //return this
        var isMine = this.filterBy('user_id', this.session.get('content.user.id') )
        return isMine
    }.property('@each.myProjects'),
    
    actions : {
        
        createProject: function() {
            
            time = (new Date()).toTimeString();
            
            var project = this.store.createRecord('project', {
                name: time,
                user_id: this.session.get('content.user.id')
            });
            
            var self = this;
            
            var onSuccess = function(project) {
                
                var newProject = DS.PromiseObject.create({
                    promise: App.Project.store.fetch('project', { name: time })
                });
    
                newProject.then(function() {
                    //console.log(newProject)
                    self.transitionToRoute('project', newProject.get('content.content.0.id'));
                });
            };
            project.save().then(onSuccess);

        },
        
        deleteProject: function(project) {
            //console.log(project);
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
    
    isMine: false,
    
    mine: function() {
        var _this = this;
        var currentProject = DS.PromiseObject.create({
            promise: this.store.find('project', this.model.id)
        });
        
        currentProject.then(function() {
            
            if (currentProject.get('user_id') === _this.session.content.user.id) {
                //console.log(_this.session.content.user.id)
                _this.set('isMine', true);    
            }
            else {
                _this.set('isMine', false);
            }
        });
    }.property('model'),
    
    // Empty property for the input filed so we can clear it later.
    projectName: '',
    
    savedStatus: function() {
        ////console.log(this);
    }.property(),
    
    actions: {
        reload: function() {
          this.get('model').reload().then(function(model) {
          });
        },
      
        updateProject: function() {
            var project = this.get('model')
            var submittedName = this.get('projectName')
            if(submittedName === '') {
                alert('Please add a title for you project.')
            }
            else {
                project.set('name', submittedName)
                project.set('saved', true);
                
                // perserve this so we can clear the projectName field after save.
                var controller = this;
                project.save().then(function(project){
                    // Clear the projectName filed.
                    controller.set('projectName', '');    
                });
            }
        },
    }
});

App.AddLayerModalController = Ember.ArrayController.extend({
   sortProperties: ['layer_type', 'name'],
});

App.LoginController  = Ember.Controller.extend(SimpleAuth.LoginControllerMixin, {
    authenticator: 'simple-auth-authenticator:oauth2-password-grant',
});
 

// Routes

Ember.Route.reopen({
  activate: function() {
    var cssClass = this.toCssClass();
    // you probably don't need the application class
    // to be added to the body
    if (cssClass != 'application') {
      Ember.$('body').addClass(cssClass);
    }
  },
  deactivate: function() {
    Ember.$('body').removeClass(this.toCssClass());
  },
  toCssClass: function() {
    return this.routeName.replace(/\./g, '-').dasherize();
  }
});

App.ApplicationRoute = Ember.Route.extend(SimpleAuth.ApplicationRouteMixin);

App.IndexRoute = Ember.Route.extend({});

// Is this needed?
App.AddLayerModalRoute = Ember.Route.extend({
    model: function() {
        // return this.store.find('layer');
    },
});

App.ProjectsIndexRoute = Ember.Route.extend({
    model: function() {
        return this.store.find('project');
    }
    
});

//App.ProjectRoute = Ember.Route.extend(SimpleAuth.AuthenticatedRouteMixin,{
App.ProjectRoute = Ember.Route.extend({
    
    model: function(params) {
        return this.store.fetch('project', params.project_id);
    },
    
    afterModel: function(model) {
        //model.reload();
        //console.log('afterModel ' + Counts.vectorLayer)
        //Counts.set('vectorLayer', 0)
    },

    actions: {
        addLayer: function(layer, model) {
            var layerID = layer.get('id');
            var _this = this;
            var projectID = _this.get('controller.model.id');
            //console.log(Counts.vectorLayer)
            var projectlayer = this.store.createRecord('projectlayer', {
                project_id: projectID,
                layer_id: layerID,
                marker: Counts.vectorLayer
            });
            projectlayer.save().then(function(){
                $("div").removeClass("vectorData");
                Counts.set('vectorLayer', 0)
              _this.get("controller.model").reload();
            });
        },
        
        removeLayer: function(layer, project) {
            var layerID = layer.get('id');
            var layerClass = layer.get('layer');
            var _this = this;
            var p = project || this.get("controller.model.id");

            var projectLayer = DS.PromiseObject.create({
                promise: this.store.find('projectlayer', { layer_id: layerID, project_id: p })
            });

            projectLayer.then(function() {
                var projectLayerID = projectLayer.get('content.content.0.id');
                    //console.log(projectLayer);
                
                App.Projectlayer.store.find('projectlayer', projectLayerID).then(function(projectlayer){
                    //console.log(projectlayer)
                    projectlayer.destroyRecord().then(function(){
                        Counts.set('vectorLayer', 0)
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

App.LoginRoute = Ember.Route.extend(SimpleAuth.UnauthenticatedRouteMixin);

App.Projectlayer = Ember.Route.extend({
    model: function() {
        return App.Projectlayer.find()
    }
});

// Views

// Components

App.BaseMapComponent = Ember.Component.extend({
    didInsertElement: function() {
        
        var map = L.map('map', {
            center: [33.7489954,-84.3879824],
            zoom: 13,
            zoomControl:false 
        });
        
        var osm = L.tileLayer('http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors Georgia State University and Emory University',
            detectRetina: true
        }).addTo(map);
        
        var MapQuestOpen_Aerial = L.tileLayer('http://oatile{s}.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg', {
            attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency contributors Georgia State University and Emory University',
            subdomains: '1234',
            detectRetina: true
        });
        
        var toner = L.tileLayer('http://d.tile.stamen.com/toner/{z}/{x}/{y}.png', {
          attribution: '&copy; <a href="http://osm.org/copyright">Stamen Toner Map</a> contributors Georgia State University and Emory University',
          detectRetina: true
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
                    var slider = $("input.slider, input ."+layerName).slider({
                        value: 10,
                        reversed: true,
                    });
        
                });
    }.property(),
    
    actions: {
        opacityChange: function() {
            var layerName = this.layer
            var value = $("input."+layerName).val();
            var opacity = value / 10;
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
        
        //if (Counts.vectorLayer == 7) {
        //    Counts.set('vectorLayer', 0)
        //}
        //console.log('was reset to ' + Counts.vectorLayer)
        
        var markerFor = ''//Counts.vectorLayer;
        var _this = this;

        var savedMarker = DS.PromiseObject.create({
            promise: App.Project.store.find('projectlayer', { project_id: this.projectID, layer_id: this.layerID })
        });

        savedMarker.then(function() {
            //console.log(savedMarker.content.content[0]._data.marker)
            if(typeof savedMarker.content.content[0]._data.marker !== "undefined") {
                _this.set('markerFor', savedMarker.content.content[0]._data.marker)
                markerFor = savedMarker.content.content[0]._data.marker;
                console.log('marker fond in DB ' + markerFor + ' Count is still ' + Counts.vectorLayer)
            }
        });
        
        
        //console.log(Counts.vectorLayer)

        var mappedLayer = DS.PromiseObject.create({
            promise: App.Layer.store.find('layer', this.layerID)
        });
        mappedLayer.then(function() {console.log('Adding ' + mappedLayer.get('name'))});
        var promises = [savedMarker, mappedLayer];
        
        Ember.RSVP.allSettled(promises).then(function(array){
            //console.log('count: ' + Counts.vectorLayer)
            //console.log('marker: ' + markerFor)
            var slug = mappedLayer.get('layer');
            var map = store.get('map');
            
            //console.log('markerFor is set at ' + markerFor)
            
            institution = mappedLayer.get('institution');
            
            switch(mappedLayer.get('layer_type')) {
                case 'planningatlanta':

                    var tile = L.tileLayer('http://static.library.gsu.edu/ATLmaps/tiles/' + mappedLayer.get('layer') + '/{z}/{x}/{y}.png', {
                        layer: mappedLayer.get('layer'),
                        tms: true,
                        minZoom: 13,
                        maxZoom: 19,
                        detectRetina: true
                    }).addTo(map).setZIndex(10).getContainer();
                                        
                    $(tile).addClass(slug);

                    break;
                
                case 'wms':
                
                    var wmsLayer = L.tileLayer.wms(institution.geoserver + mappedLayer.get('url') + '/wms', {
                        layers: mappedLayer.get('url') + ':' + mappedLayer.get('layer'),
                        format: 'image/png',
                        CRS: 'EPSG:900913',
                        transparent: true,
                        detectRetina: true
                    }).addTo(map).bringToFront().getContainer();
                                        
                    $(wmsLayer).addClass(slug);
                
                    break;
                
                case 'wfs':
                                    //http://geospatial.library.emory.edu:8081/geoserver/Sustainability_Map/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Sustainability_Map:Art_Walk_Points&maxFeatures=50&outputFormat=text%2Fjavascript&format_options=callback:processJSON&callback=jQuery21106192189888097346_1421268179487&_=1421268179488
                                    //http://geospatial.library.emory.edu:8081/geoserver/Sustainability_Map/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Sustainability_Map:Art_Walk_Points&maxFeatures=50&outputFormat=text/javascript
                    var wfsLayer = institution.geoserver + mappedLayer.get('url') + "/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=" + mappedLayer.get('url') + ":" + mappedLayer.get('layer') + "&maxFeatures=50&outputFormat=text%2Fjavascript&format_options=callback:processJSON";
                    //console.log(wfsLayer)
                    
                    $.ajax(wfsLayer,
                      { dataType: 'jsonp' }
                    ).done(function ( data ) {});
                    
                    // This part is the magic that makes the JSONP work
                    // The string at the beginning of the JSONP is processJSON
                    function processJSON(data) {
                      points = wfsLayer(data,{
                        //onEachFeature: onEachFeature,
                        pointToLayer: function (feature, latlng) {
                          return L.marker(latlng);
                        }
                      }).addTo(map);
                    }
                    
                    break;
                
                case 'geojson':
                    
                    // So this count is no longer doing anything but the increment needs to be moved
                    // and this whole process needs to be cleaned up.
                    
                    if (Counts.vectorLayer === 10) {
                        console.log('i am resetting')
                        Counts.set('vectorLayer', -1)
                        console.log(Counts.vectorLayer)
                    }
                    Counts.vectorLayer++
                    //console.log('count = ' + Counts.vectorLayer)
                    
                    var slug = mappedLayer.get('layer')
                    
                    function viewData(feature, layer) {
                        var popupContent = "<h2>"+feature.properties.name+"</h2>"
                        if (feature.properties.image) {
                            popupContent += "<img class='geojson' src='"+feature.properties.image.url+"' title='"+feature.properties.image.name+"' />"+
                                            "<span>Photo Credit: "+feature.properties.image.credit+"</span>";
                        };
                        popupContent += "<p>"+feature.properties.description+"</p>";
                        //layer.bindPopup(popupContent);
                        layer.on('click', function(marker) {
                            //console.log(marker);
                            $(".shuffle-items li.item.info").remove();
                            var $content = $("<div/>").attr("class","content").html(popupContent)
                            var $info = $('<li/>').attr("class","item info").append($content);
                            $info.appendTo($(".shuffle-items"))
                            shuffle.click($info);

                            //alert(App.laodCount)
                            //$("img").addClass(pointClicked);
                        });
                        
                    }
                    function setIcon(url, class_name){
                        return iconObj = L.icon({
                            iconUrl: url,
                            iconSize: [25, 35],
                            iconAnchor: [16, 37],
                            //popupAnchor: [0, -28],
                            className: class_name
                        });
                    }
                    
                    if(mappedLayer.get('url')){
                      var points = new L.GeoJSON.AJAX(mappedLayer.get('url'), {
                          pointToLayer: function (feature, latlng) {
                            var layerClass = 'marker' + String(Counts.marker++) + ' ' + slug + ' vectorData' ;
                            //var markerImage = '/images/markers/' + count + '.png';
                            var markerImage = '/images/markers/' + markerFor + '.png';
                            var marker = L.marker(latlng, {icon: setIcon(markerImage, layerClass)});
                            return marker
                          },
                          onEachFeature: viewData,
                      }).addTo(map);
                      // Not sure we need to do this.
                      if (Counts.vectorLayer === markerFor) {
                        console.log('time to subtract.')
                        Counts.vectorLayer--
                      }
                      console.log('vectorLayer is ' + Counts.vectorLayer + ' markerFor is ' + markerFor)
                      
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
    tag_ids: DS.hasMany('tag', {async: true}),
    institution: DS.attr()
});

App.Project = DS.Model.extend({
    name: DS.attr('string'),
    description: DS.attr('string'),
    user: DS.attr(),
    user_id: DS.attr(),
    saved: DS.attr('boolean'),
    published: DS.attr('boolean'),
    //user: DS.attr('number'),
    layer_ids: DS.hasMany('layer', {async: true}),
});

App.Projectlayer = DS.Model.extend({
    layer_id: DS.attr(),
    project_id: DS.attr(),
    marker: DS.attr()
});

App.Tag = DS.Model.extend({
    name: DS.attr('string')
});

App.User = DS.Model.extend({
    displayname: DS.attr('string'),
    avatar: DS.attr('string')
});

$(document).ready(function(){
  $.material.ripples(".btn, .navbar a");
  $.material.input();
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
    if ($(this).hasClass('info') == false){
      $(".shuffle-items li.item.info").remove();
    }
    shuffle.click(this);
  })
  
});