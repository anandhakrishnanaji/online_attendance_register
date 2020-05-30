#from django.shortcuts import render
from api.models import Userss,Attendance
from rest_framework.decorators import api_view,authentication_classes,permission_classes
from rest_framework.response import Response
from rest_framework import status
from api.serializers import RegistrationSerializer,ProfileSerializer
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token
from django.contrib.staticfiles.storage import staticfiles_storage
import urllib
import face_recognition as fr
import datetime


@api_view(['POST'])
def registration_view(request):
    serializer=RegistrationSerializer(data=request.data)
    s=Userss.objects.filter(username=request.data['username'])
    if s: return Response(data={'username':'0'},status=status.HTTP_400_BAD_REQUEST)
    s=Userss.objects.filter(email=request.data['email'])
    if s: return Response(data={'email':'0'},status=status.HTTP_400_BAD_REQUEST)
    else: 
        if serializer.is_valid():
            j=serializer.save()
            k=serializer.data
            m=Userss.objects.get(email=k['email'])
            k['token']=Token.objects.get(user=m).key
            return Response(data=k,status=status.HTTP_201_CREATED)
        else:
            return Response(data=serializer.error_messages,status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT','POST'])
def profile_view(request):
    user=Userss.objects.get(username=request.data['username'])
    request.data['user']=user
    serializer=ProfileSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        #print(user.profile)
        #print(serializer.data['picture'])
        j={}
        j['user']=serializer.data['user']
        j['picture']=user.profile.picture.url
        return Response(data=j,status=status.HTTP_201_CREATED)
    else:
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

"""@api_view(['POST'])
def findpic(request):
    user=Userss.objects.get(username=request.data['username'])
    return Response(data=user.profile.picture.url)"""

@api_view(['POST'])
@authentication_classes((TokenAuthentication,))
@permission_classes([IsAuthenticated,])
def faceauth(request):
    user=Userss.objects.get(username=request.data['username'])
    file1=request.data['picture']
    file2=user.profile.picture

    image1 = fr.load_image_file(file1)
    image2 = fr.load_image_file(file2)
    
    try:
        image1_encoding = fr.face_encodings(image1)[0]
        image2_encoding = fr.face_encodings(image2)[0]
        results = fr.compare_faces([image1_encoding], image2_encoding)
    except:
        results=False
    data={'result':results[0]}
    #return Response(data=data,status=status.HTTP_200_OK)
    if results[0]:
        td=datetime.date.today()
        atm=Attendance.objects.filter(date=td)
        #dt=Attendance(date=td,present=False)
        users=Userss.objects.all()
        if not atm:
            for k in users:
                jam=Attendance(date=td,present=False,)
                jam.save()
                k.attendance_set.add(jam)
                k.save()
        amu=Userss.objects.get(username=request.data['username'])
        mu=Attendance.objects.get(date=td,user=amu)
        kj=mu.present
        mu.present=True
        mu.save()
        amu.save()
        if not kj: 
            print("yes")
            mu.timein=datetime.datetime.now().time()
        else:
            print("no") 
            mu.timeout =datetime.datetime.now().time()
        mu.save()
        amu.save()
    return Response(data=data)

@api_view(['POST'])
@authentication_classes((TokenAuthentication,))
@permission_classes([IsAuthenticated,])
def calcattendance(request):
    date=datetime.datetime.strptime(request.data['date'], "%Y-%m-%d").date()
    user=Userss.objects.get(username=request.data['username'])
    tl=len(user.attendance_set.exclude(date__lt=date))
    tp=len(user.attendance_set.filter(present=True).exclude(date__lt=date))
    total=(tp/tl)*100
#print(str(round(total,2))
    return Response({'result':str(round(total,2))})

@api_view(['POST'])
@authentication_classes((TokenAuthentication,))
@permission_classes([IsAuthenticated,])
def changepassword(request):
    j=Userss.objects.get(username=request.data['username'])
    j.set_password(request.data['password'])
    j.save()
    return Response({'result':'true'})

