from tastypie.utils.timezone import now
from django.db import models
from mongoengine import Document
from mongoengine import fields


class Layers(Document):
    name = fields.StringField()
    slug = fields.StringField()
    keywords = fields.StringField()
    description = fields.StringField()
    url = fields.StringField()
    layer = fields.StringField()
    date = fields.DateTimeField()
    type = fields.StringField()
    bbox = fields.StringField()
    miny = fields.StringField()
    id = fields.StringField()
    zoomlevels = fields.ListField()
    layerCollection = fields.StringField()
    v = fields.IntField()

    # This doesn't have to be set as long as all the fields line up.
    # Seems like a good idea to keep it.
    meta = {'collection': 'layers'}

class LayerCollection(Document):
    name = fields.StringField()
    slug = fields.StringField()
    id = fields.StringField()
    v = fields.IntField()
    
    meta = {'collection': 'layercollection'}