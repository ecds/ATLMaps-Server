from django.conf.urls import patterns, url, include
from tastypie.api import Api
from atlmaps.apps.maps.api.resources import LayersResource, LayerCollectionResource

v1_api = Api(api_name='v1')
v1_api.register(LayersResource())
v1_api.register(LayerCollectionResource())

#layers_resource = LayersResource()
#layercollection_resource = LayerCollectionResource()

urlpatterns = patterns('atlmaps.apps.maps.api',
#    (r'^api/', include(layers_resource.urls)),
#    (r'^api/', include(layercollection_resource.urls)),
    (r'^api/', include(v1_api.urls)),
)