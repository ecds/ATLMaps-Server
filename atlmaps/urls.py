from django.conf.urls import patterns, include, url
from django.contrib import admin
#from rest_framework import routers
#from apps.maps.views import LayerViewSet

admin.autodiscover()

#router = routers.DefaultRouter()
#router.register(r'layers', LayerViewSet)

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    #url(r'^', include(router.urls)),
    url(r'^maps/', include('atlmaps.apps.maps.urls', namespace="maps")),
)