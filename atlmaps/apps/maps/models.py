from tastypie.utils.timezone import now
from django.contrib.auth.models import User
from django.db import models
from django.utils.text import slugify
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
    _id = fields.StringField()
    zoomlevels = fields.ListField(fields.EmbeddedDocumentField('zoomlevels'))
    layerCollection = fields.StringField()
    __v = fields.StringField()

    class Meta:
	db_table = 'layers'