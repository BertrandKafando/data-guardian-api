from .base import *

if env('ENV_MODE') == 'prod':
   from .prod import *
elif env('ENV_MODE') == 'dev':
   from .dev import *
