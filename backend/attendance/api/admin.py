from django.contrib import admin

# Register your models here.
from .models import Userss,Profile,Attendance
admin.site.register(Userss)
admin.site.register(Profile)
admin.site.register(Attendance)