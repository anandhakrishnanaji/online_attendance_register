from django.urls import path
from api.views import(
	registration_view,profile_view,faceauth,calcattendance,changepassword,changeemail
)

from rest_framework.authtoken.views import obtain_auth_token

app_name = 'api'

urlpatterns = [
	path('register/', registration_view, name="register"),
	path('login/', obtain_auth_token, name="login"), 
	path('profile/',profile_view,name="profile"),
	path('faceauth/',faceauth,name="faceauth"),
	path('calcattendance/',calcattendance,name="calcattendance"),
	path('changepassword/',changepassword,name="changepassword"),
	path('changeemail/',changeemail,name="changeemail"),
]
