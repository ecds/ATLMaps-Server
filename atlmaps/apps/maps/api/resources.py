from tastypie.resources import ModelResource
from tastypie_mongoengine import resources
from tastypie import authorization
from tastypie import fields
from tastypie.resources import ModelResource, ALL, ALL_WITH_RELATIONS
from atlmaps.apps.maps.documents import Layers, LayerCollection

class LayersResource(resources.MongoEngineResource):

    class Meta:
        queryset = Layers.objects.all()
        #queryset = Layers.objects(layer='atl1919')
        allowed_methods = ('get')
        resource_name = 'layers'
        authorization = authorization.ReadOnlyAuthorization()
        filtering = {
            'slug': ALL,
        }

        #def get_object_list(self, request, dim):
    #    print(dim)
    #    #return super(Layers, self).get_object_list(request).filter(start_date__gte=now)

class LayerCollectionResource(resources.MongoEngineResource):
    
    class Meta:
        queryset = LayerCollection.objects.all()
        allowed_methods = ('get')
        resource_name = 'layercollection'
        authorization = authorization.ReadOnlyAuthorization()
