window.ENV = window.ENV || {};
window.ENV['simple-auth'] = {
    authorizer: 'simple-auth-authorizer:oauth2-bearer',
};

window.ENV['simple-auth-oauth2'] = {
    serverTokenEndpoint: 'http://api.atlmaps-dev.com:7000/oauth/token',
    serverTokenRevocationEndpoint: 'http://api.atlmaps-dev.com:7000/oauth/revoke',
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
    vectorLayer: 1,
    marker: 0,
    lastAdded: 0
});

App.Map = Ember.Object.extend();
var store = App.Map.create();

//App.ApplicationController = Ember.Controller.extend({});

App.ProjectsIndexController = Ember.ArrayController.extend({
    sortProperties: ['name'],
    
    myProjects: function() {
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
                    self.transitionToRoute('project', newProject.get('content.content.0.id'));
                });
            };
            project.save().then(onSuccess);

        },
        
        deleteProject: function(project) {
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
                _this.set('isMine', true);    
            }
            else {
                _this.set('isMine', false);
            }
        });
    }.property('model'),
    
    // Empty property for the input filed so we can clear it later.
    projectName: '',
    
    // Does this do anything?
    savedStatus: function() {}.property(),
    
    actions: {
        reload: function() {
          this.get('model').reload().then(function(model) {
          });
        },
      
        saveProject: function() {
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
        
        showEditForm: function() {
            $("#project_edit_form").show();
        },
        
        cancelUpdate: function() {
            $("#project_edit_form").hide();
        },
        
        updateProject: function() {
            var project = this.get('model');
            var submittedName = project.get('name');
            var submittedDescription = project.get('description');

            project.set('name', submittedName)
            project.set('description', submittedDescription);
            
            console.log(submittedName)
            
            project.save().then(function(){
                $("#project_edit_form").hide();
            });
        },
    }
});

App.AddLayerModalController = Ember.ArrayController.extend({
   sortProperties: ['layer_type', 'name'],
});

App.EditProjectModalController = Ember.ObjectController.extend({});

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
App.AddLayerModalRoute = Ember.Route.extend({});

App.EditProjectModalRoute = Ember.Route.extend({
    model: function() {
        // return this.store.find('layer');
    }    
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
    
    // This was causing an extra trip to the database and `fetch` seemes to be
    // doing what we need. I just left this here as an example for the future.
    afterModel: function(model) {
        //model.reload();
    },

    actions: {
        addLayer: function(layer, model) {
            var layerID = layer.get('id');
            var _this = this;
            var projectID = _this.get('controller.model.id');
            
            // We only have 10 markers right now (0-9), so we need to reset if we
            // `Counts.vectorLayer` grows above 9.
            if (Counts.vectorLayer > 9) {
                Counts.set('vectorLayer', 1);
                Counts.set('lastAdded', 0);
            }
            
            var projectlayer = this.store.createRecord('projectlayer', {
                project_id: projectID,
                layer_id: layerID,
                marker: parseInt(Math.floor((Math.random() * 266) + 1)),
                layer_type: layer.get('layer_type')
            });
            
            // Peg `Counts.lastAdded` to what we just saved in the model but only if it is GeoJSON.
            if (layer.get('layer_type') === 'geojson'){
                console.log('this is geojson so we are going to mess with the counts')
                Counts.set('lastAdded', Counts.vectorLayer);
                // Now increment `Counts.vectorLayer
                Counts.vectorLayer++
            }

            projectlayer.save().then(function(){
                // This is sort of too bad, but we need to clear the vector layers off the map
                // otherwise they will added again
                $("div").removeClass("vectorData");
                
                // We need to set `Counts.vectorLayer` back to zero becuase it will increment
                // with each vector layer readded
                //Counts.set('vectorLayer', 0)
                
                _this.get("controller.model").reload();
                console.log('after save vl = ' + Counts.vectorLayer + ' la = ' + Counts.lastAdded)
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
                
                App.Projectlayer.store.find('projectlayer', projectLayerID).then(function(projectlayer){
                    projectlayer.destroyRecord().then(function(){
                        //Counts.set('vectorLayer', 0)
                        _this.get("controller.model").reload();
                    });
                });

            });
            
            console.log('vl = ' + Counts.vectorLayer + ' la = ' + Counts.lastAdded)
            Counts.vectorLayer++;
            Counts.lastAdded++;
            console.log('vl = ' + Counts.vectorLayer + ' la = ' + Counts.lastAdded)
            
            // Remove the layer from the map
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
        showEditModal: function(name) {
            var content = this.store.find('project', this.currentModel.id)
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

App.LayerMarkerComponent = Ember.Component.extend({
    tagName:'',
    markerPath: function() {
        var _this = this;
        var markerPath = '';
        
        var layerMarker = DS.PromiseObject.create({
            promise: App.Project.store.find('projectlayer', { project_id: this.projectID, layer_id: this.layerID })
        });
        
        layerMarker.then(function() {
            if (layerMarker.content.content[0]._data.layer_type == 'geojson') {
                _this.set('markerPath', '/images/markers/' + layerMarker.content.content[0]._data.marker + '.png')
            }
            else {
                _this.set('markerPath', '/images/markers/layers.png')
            }
        });

        return '/images/loading.GIF'
    
    }.property('markerPath.@each')
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

App.LayerModalComponent = Ember.Component.extend({
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

var color_options = ["amber","amber-100","amber-200","amber-300","amber-400","amber-50","amber-500","amber-600","amber-700","amber-800","amber-900","amber-A100","amber-A200","amber-A400","amber-A700","blue","blue-100","blue-200","blue-300","blue-400","blue-50","blue-500","blue-600","blue-700","blue-800","blue-900","blue-A100","blue-A200","blue-A400","blue-A700","blue-grey","blue-grey-100","blue-grey-200","blue-grey-300","blue-grey-400","blue-grey-50","blue-grey-500","blue-grey-600","blue-grey-700","blue-grey-800","blue-grey-900","blue-grey-A100","blue-grey-A200","blue-grey-A400","blue-grey-A700","brown","brown-100","brown-200","brown-300","brown-400","brown-50","brown-500","brown-600","brown-700","brown-800","brown-900","brown-A100","brown-A200","brown-A400","brown-A700","cyan","cyan-100","cyan-200","cyan-300","cyan-400","cyan-50","cyan-500","cyan-600","cyan-700","cyan-800","cyan-900","cyan-A100","cyan-A200","cyan-A400","cyan-A700","deep-orange","deep-orange-100","deep-orange-200","deep-orange-300","deep-orange-400","deep-orange-50","deep-orange-500","deep-orange-600","deep-orange-700","deep-orange-800","deep-orange-900","deep-orange-A100","deep-orange-A200","deep-orange-A400","deep-orange-A700","deep-purple","deep-purple-100","deep-purple-200","deep-purple-300","deep-purple-400","deep-purple-50","deep-purple-500","deep-purple-600","deep-purple-700","deep-purple-800","deep-purple-900","deep-purple-A100","deep-purple-A200","deep-purple-A400","deep-purple-A700","green","green-100","green-200","green-300","green-400","green-50","green-500","green-600","green-700","green-800","green-900","green-A100","green-A200","green-A400","green-A700","grey","grey-100","grey-200","grey-300","grey-400","grey-50","grey-500","grey-600","grey-700","grey-800","grey-900","grey-A100","grey-A200","grey-A400","grey-A700","indigo","indigo-100","indigo-200","indigo-300","indigo-400","indigo-50","indigo-500","indigo-600","indigo-700","indigo-800","indigo-900","indigo-A100","indigo-A200","indigo-A400","indigo-A700","light-blue","light-blue-100","light-blue-200","light-blue-300","light-blue-400","light-blue-50","light-blue-500","light-blue-600","light-blue-700","light-blue-800","light-blue-900","light-blue-A100","light-blue-A200","light-blue-A400","light-blue-A700","light-green","light-green-100","light-green-200","light-green-300","light-green-400","light-green-50","light-green-500","light-green-600","light-green-700","light-green-800","light-green-900","light-green-A100","light-green-A200","light-green-A400","light-green-A700","lime","lime-100","lime-200","lime-300","lime-400","lime-50","lime-500","lime-600","lime-700","lime-800","lime-900","lime-A100","lime-A200","lime-A400","lime-A700","orange","orange-100","orange-200","orange-300","orange-400","orange-50","orange-500","orange-600","orange-700","orange-800","orange-900","orange-A100","orange-A200","orange-A400","orange-A700","pink","pink-100","pink-200","pink-300","pink-400","pink-50","pink-500","pink-600","pink-700","pink-800","pink-900","pink-A100","pink-A200","pink-A400","pink-A700","purple","purple-100","purple-200","purple-300","purple-400","purple-50","purple-500","purple-600","purple-700","purple-800","purple-900","purple-A100","purple-A200","purple-A400","purple-A700","red","red-100","red-200","red-300","red-400","red-50","red-500","red-600","red-700","red-800","red-900","red-A100","red-A200","red-A400","red-A700","teal","teal-100","teal-200","teal-300","teal-400","teal-50","teal-500","teal-600","teal-700","teal-800","teal-900","teal-A100","teal-A200","teal-A400","teal-A700","yellow","yellow-100","yellow-200","yellow-300","yellow-400","yellow-50","yellow-500","yellow-600","yellow-700","yellow-800","yellow-900","yellow-A100","yellow-A200","yellow-A400","yellow-A700"];

App.MapLayersComponent = Ember.Component.extend({
    mappedLayers: function() {
        
        var markerFor = ''//Counts.vectorLayer;
        var _this = this;

        var savedMarker = DS.PromiseObject.create({
            promise: App.Project.store.find('projectlayer', { project_id: this.projectID, layer_id: this.layerID })
        });

        savedMarker.then(function() {
            if(typeof savedMarker.content.content[0]._data.marker !== "undefined") {
                _this.set('markerFor', savedMarker.content.content[0]._data.marker)
                markerFor = savedMarker.content.content[0]._data.marker;
            }
        });

        var mappedLayer = DS.PromiseObject.create({
            promise: App.Layer.store.find('layer', this.layerID)
        });
        
        mappedLayer.then(function() {});
        
        var promises = [savedMarker, mappedLayer];
        
        Ember.RSVP.allSettled(promises).then(function(array){
            var slug = mappedLayer.get('layer');
            var map = store.get('map');
            
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
                    
                    var slug = mappedLayer.get('layer')
                    
                    function viewData(feature, layer) {
                        var popupContent = "<h2>"+feature.properties.name+"</h2>"
                        if (feature.properties.image) {
                            popupContent += "<img class='geojson' src='"+feature.properties.image.url+"' title='"+feature.properties.image.name+"' />"+
                                            "<span>Photo Credit: "+feature.properties.image.credit+"</span>";
                        };
                        if (feature.properties.gx_media_links) {
                            popupContent += '<iframe width="375" height="250" src="//' + feature.properties.gx_media_links + '?modestbranding=1&rel=0&showinfo=0&theme=light" frameborder="0" allowfullscreen></iframe>'
                        }
                        popupContent += "<p>"+feature.properties.description+"</p>";
                        //layer.bindPopup(popupContent);
                        layer.on('click', function(marker) {
                            $(".shuffle-items li.item.info").remove();
                            var $content = $("<div/>").attr("class","content").html(popupContent)
                            var $info = $('<li/>').attr("class","item info").append($content);
                            $info.appendTo($(".shuffle-items"))
                            shuffle.click($info);

                            console.log(this)
                            $(".active_marker").removeClass("active_marker");
                            $(this._icon).addClass('active_marker');
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
                           var i = markerFor;
                           var layerClass = 'marker' + String(Counts.marker++) + ' ' + slug + ' vectorData map-marker layer-' + color_options[i];
                           
                           var icon = L.divIcon({
                               className: layerClass,
                               iconSize: null,
                               html: '<div class="shadow"></div><div class="icon"></div>'
                           });
                           
                           var marker = L.marker(latlng, {icon: icon}); 
                          
                          
                          // pointToLayer: function (feature, latlng) {
                          //   var layerClass = 'marker' + String(Counts.marker++) + ' ' + slug + ' vectorData' ;
                          //   var markerImage = '/images/markers/' + markerFor + '.png';
                          //   var marker = L.marker(latlng, {icon: setIcon(markerImage, layerClass)});
                          //   
                          //   
                            
                            return marker
                          },
                          
                          
                          onEachFeature: viewData,
                      }).addTo(map);
                      
                      
                    }
                    
                    //// Trust me, I feel guilty about the following code. `Counts.vectorLayer` always need to be
                    //// one greater than `Counts.lastAdded`. In general it is fine without this. Where things get
                    //// off track is when a user starts removing layers. We can always trust `Counts.lastAdded` as
                    //// it is only set when the model is saved.
                    //if (Counts.vectorLayer === Counts.lastAdded) {
                    //    Counts.vectorLayer++
                    //}
                    //else if (Counts.vectorLayer > (Counts.lastAdded + 1)) {
                    //    console.log('we are doing that crappy thing')
                    //    Counts.set('vectorLayer', Counts.lastAdded + 1)
                    //}
                      
                    break;
                    
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
    marker: DS.attr(),
    layer_type: DS.attr()
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
