from rest_framework.viewsets import ModelViewSet
from .serializers import *
from rest_framework.response import Response
from .models import *
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .permissions import *
from django.contrib.auth import authenticate, login
from .authentication import *
from django.contrib.auth import logout
from .utils import Base64
import os
from django.core.files.base import ContentFile
from rest_framework.views import APIView
from django.db.models import Q
import pandas as pd
from django.conf import settings
import environ
import json
from django.db import transaction



env = environ.Env()
environ.Env.read_env()
BASE_DIR = settings.BASE_DIR

