from rest_framework.permissions import BasePermission
from .authentication import *


# When a request is sent from a client that includes an authentication token, 
# the Django authentication middleware will validate the token and 
# set the request.user attribute to the user associated with the token.


class IsCustomerAuthenticated(BasePermission):
 
    def has_permission(self, request, view):
    # accès aux utilisateurs utilisateurs authentifiés
        if request.user.is_anonymous:
            return False
        else:
            token, _ = Token.objects.get(user = request.user)
            is_expired = is_token_expired(token) 
            if is_expired :
                token.delete()
                request.user.is_authenticated=False
                return False
            else:
                return bool(request.user and request.user.is_authenticated and request.user.has_perm("DataGuardianApp.is_customer") and not is_expired)


class IsAdminAuthenticated(BasePermission):
     
    def has_permission(self, request, view):
    # accès aux Administrateurs authentifiés
        if request.user.is_anonymous:
            return False
        else:
            token, _ = Token.objects.get(user = request.user)
            is_expired = is_token_expired(token) 
            if(is_expired):
                token.delete()
                request.user.is_authenticated=False
                return False
            else:
                return bool(request.user and request.user.is_authenticated and request.user.has_perm("DataGuardianApp.is_admin") and not is_expired)