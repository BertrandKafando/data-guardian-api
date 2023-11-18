from rest_framework import serializers 
from .models import *
from django.contrib.auth.models import User, Permission
from django.contrib.contenttypes.models import ContentType
from rest_framework.exceptions import  NotFound
from drf_extra_fields.fields import Base64ImageField
import base64
import os
import pytz
from django.utils import timezone
from .utils import Base64
from django.core.files.base import ContentFile
from uuid import uuid4




utc = pytz.UTC
now = timezone.now()

