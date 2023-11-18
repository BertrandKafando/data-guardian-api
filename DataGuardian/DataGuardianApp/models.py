from django.db import models
from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator, FileExtensionValidator, RegexValidator
from django.utils.timezone import now
from django.contrib.auth.hashers import make_password
import os
import datetime
from django.utils import timezone
