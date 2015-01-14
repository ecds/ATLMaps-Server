window.ENV = window.ENV || {};
window.ENV['simple-auth'] = {
    authorizer: 'simple-auth-authorizer:oauth2-bearer',
    //session: 'session:custom',
};

window.ENV['simple-auth-oauth2'] = {
    serverTokenEndpoint: 'http://atlmaps-dev.com:7000/oauth/token',
    serverTokenRevocationEndpoint: 'http://atlmaps-dev.com:7000/oauth/revoke',
};

//Ember.Application.initializer({
//    name: 'authentication',
//    before: 'simple-auth',
//    initialize: function(container, application) {
//        console.log(container);
//        container.register('session:custom', App.CustomSession);
//    }
//});

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

// the custom authenticator that handles the authenticated account
//App.CustomAuthenticator = SimpleAuth.Authenticators.OAuth2.extend({
//  authenticate: function(credentials) {
//    return new Ember.RSVP.Promise(function(resolve, reject) {
//      // make the request to authenticate the user at endpoint /v3/token
//      Ember.$.ajax({
//        url:  'http://atlmaps-dev.com:7000/oauth/token',
//        type: 'POST',
//        data: { grant_type: 'password', username: credentials.identification, password: credentials.password }
//      }).then(function(response) {
//        Ember.run(function() {
//          // resolve (including the account id) as the AJAX request was successful; all properties this promise resolves
//          // with will be available through the session
//          resolve({ access_token: response.access_token, account_id: response.account_id });
//        });
//      }, function(xhr, status, error) {
//        Ember.run(function() {
//          reject(xhr.responseText);
//        });
//      });
//    });
//  }
//});

var layersStore = Ember.Object.create({
  loaded: []
});

// Controllers

var user = Ember.Object.create({
        value:'User'
    });

App.ApplicationController = Ember.Controller.extend({
    //user_value: '',
    //currentUser: function() {
    //    var token = this.session.get('content.access_token')
    //    var self = this;
    //    console.log(token)
    //    var request = $.ajax({
    //        url: "http://api.atlmaps-dev.com:7000/v1/tokens/me.json",
    //        dataType: 'json',
    //        beforeSend: function(xhr, settings) { xhr.setRequestHeader('Authorization','Bearer ' + token); }
    //    });
    //    request.done(function(json) {
    //        console.log(json)
    //        console.log(json.id)
    //        console.log(json.email)
    //        user.set('value',json);
    //        self.set('user_value',json.email);
    //    });
    //    console.log(user.get('value'));
    //}.property(),
    
    mine: function() {
        return true
    }
    
});

App.ProjectsIndexController = Ember.ArrayController.extend({
    sortProperties: ['name'],
    
    //user_value: Ember.computed.alias('controllers.application.user_value'),
    //
    //needs: ['application'],
    //currentUser: Ember.computed.alias('controllers.application.currentUser'),
    
    myProjects: function() {
        console.log(this.session.get('content.user.id'))
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
                    console.log(newProject)
                    self.transitionToRoute('project', newProject.get('content.content.0.id'));
                });
            };
            project.save().then(onSuccess);

        },
        
        deleteProject: function(project) {
            console.log(project);
            //alert('ARE YOU SURE YOU WANT TO DELETE THIS PROJECT? THERE IS NO GETTING IT BACK!')
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
                console.log(_this.session.content.user.id)
                _this.set('isMine', true);    
            }
            else {
                _this.set('isMine', false);
            }
        });
    }.property('model'),
    
    // Empty property for the input filed so we can clear it later.
    projectName: '',
    
    getLayers: function(){
        loaded_layers = this.get("model.layer_ids").content.content.length;
        // Needs to be changed to this if with go with ember data beta 14    
        //loaded_layers = this.get("model.layer_ids").content.length;
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
            console.log('hello');
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
    //authenticator: 'authenticator:custom'
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
        console.log(this.session)
        return this.store.find('project');
    }
    
});

//App.ProjectRoute = Ember.Route.extend(SimpleAuth.AuthenticatedRouteMixin,{
App.ProjectRoute = Ember.Route.extend({
    
    model: function(params) {
        return this.store.find('project', params.project_id);
    },
    
    afterModel: function(model) {
        model.reload();
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
            var p = project || this.get("controller.model.id");

            var projectLayer = DS.PromiseObject.create({
                promise: this.store.find('projectlayer', { layer_id: layerID, project_id: p })
            });

            projectLayer.then(function() {
                var projectLayerID = projectLayer.get('content.content.0.id');
                    console.log(projectLayer);
                
                App.Projectlayer.store.find('projectlayer', projectLayerID).then(function(projectlayer){
                    console.log(projectlayer)
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

App.LoginRoute = Ember.Route.extend(SimpleAuth.UnauthenticatedRouteMixin);


App.Map = Ember.Object.extend();
var store = App.Map.create();

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
                
                case 'geojson':
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
                            console.log(marker);
                            $(".shuffle-items li.item.info").remove();
                            var $content = $("<div/>").attr("class","content").html(popupContent)
                            var $info = $('<li/>').attr("class","item info").append($content);
                            $info.appendTo($(".shuffle-items"))
                            shuffle.click($info);
                        });
                        
                    }
                    function setIcon(url, class_name){
                      return iconObj = L.icon({
                                            iconUrl: url,
                                            //iconSize: [50, 65],
                                            iconAnchor: [16, 37],
                                            //popupAnchor: [0, -28],
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
    project_id: DS.attr()
});

App.Tag = DS.Model.extend({
    name: DS.attr('string')
});

App.User = DS.Model.extend({
    displayname: DS.attr('string'),
    avatar: DS.attr('string')
});

//App.CustomSession = SimpleAuth.Session.extend({
//  account: function() {
//    consloe.log('oh hi there')
//    var accountId = this.get('account_id');
//    if (!Ember.isEmpty(accountId)) {
//        console.log('oh good')
//        console.log(this.container.lookup('store:main').find('account', accountId))
//        return this.container.lookup('store:main').find('account', accountId);
//    }
//    else {
//        return null
//    }
//  }.property('account_id')
//});

//App.register('session:custom', App.CustomSession);

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