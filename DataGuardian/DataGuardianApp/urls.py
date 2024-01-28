from django.conf.urls import url
from rest_framework.routers import DefaultRouter, SimpleRouter
from django.urls import path, include
from . import views
from .api import *
from rest_framework.permissions import IsAuthenticated
from drf_yasg.views import get_schema_view
from drf_yasg import openapi


router = SimpleRouter()
router.register(r'role', RoleViewSet, basename='role')
router.register(r'compte', CompteViewSet, basename='compte')
router.register(r'utilisateur', UtilisateurViewSet, basename='utilisateur')
router.register(r'critere', CritereViewSet, basename='critere')
router.register(r'base-de-donnees', BaseDeDonneesViewSet, basename='base-de-donnees')
router.register(r'meta-table', MetaTableViewSet, basename='meta-table')
router.register(r'meta-special-car', MetaAnomalieViewSet, basename='Meta-special-car')
router.register(r'meta-tous-contraintes', MetaTousContraintesViewSet, basename='Meta-tous-contraintes')
router.register(r'meta-colonne', MetaColonneViewSet, basename='Meta-colonne')
router.register(r'score-diagnostic', ScoreDiagnosticViewSet, basename='score-diagnostic')
router.register(r'projet', ProjetViewSet, basename='projet')


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
    url(r'^api/diagnostic/$', DiagnosticViewSet.as_view(), name='diagnostic'),
    url(r'^api/authenticate/$', LoginView.as_view(), name='login'),
    url(r'^api/logout/$', LogoutView.as_view(), name='logout'),
    url(r'^api/semantic/$', SemanticInferenceView.as_view(), name='semantic')
]