from django.conf.urls import url
from rest_framework.routers import DefaultRouter, SimpleRouter
from django.urls import path, include
from . import views
from .api import *
from rest_framework.permissions import IsAuthenticated
from drf_yasg.views import get_schema_view
from drf_yasg import openapi


router = SimpleRouter()



schema_view = get_schema_view(
    openapi.Info(
        title="Data Guardian : API ",
        default_version='v1',
        description="URIs de l'API :",
    ),
    public=True,
    permission_classes=()
)

urlpatterns = [
    url(r'api/', include(router.urls)),
    url(r'^$', schema_view.with_ui('swagger', cache_timeout=0), name='documentation'),
]