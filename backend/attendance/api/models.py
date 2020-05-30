from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager,User
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token

class Userss(User):
    def __str__(self):
        return self.username
    
    
@receiver(post_save, sender=Userss)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        print('hred')
        Token.objects.create(user=instance)


class Profile(models.Model):
    user=models.OneToOneField(Userss,on_delete=models.CASCADE)
    picture=models.ImageField(upload_to='pictures/faces/',max_length=255,null=True,blank=True)

    def __str__(self):
        return self.user.username

class Attendance(models.Model):
    user=models.ForeignKey(Userss,on_delete=models.CASCADE,null=True)
    date=models.DateField(null=True,blank=True)
    present=models.BooleanField(default=False)
    timein=models.TimeField(null=True,blank=True)
    timeout=models.TimeField(null=True,blank=True)

    def __str__(self):
        return self.user.username
