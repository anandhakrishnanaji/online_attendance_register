from rest_framework import serializers
from api.models import Userss,Profile


class RegistrationSerializer(serializers.ModelSerializer):

	password2 = serializers.CharField(style={'input_type': 'password'}, write_only=True)

	class Meta:
		model = Userss
		fields = ['email', 'username', 'password', 'password2']
		extra_kwargs = {
				'password': {'write_only': True},
		}	


	def	save(self):

		account = Userss(
					email=self.validated_data['email'],
					username=self.validated_data['username'],
					#picture=self.validated_data['picture']
				)
		password = self.validated_data['password']
		password2 = self.validated_data['password2']
		account.set_password(password)
		account.save()
		return account

class ProfileSerializer(serializers.ModelSerializer):
	class Meta:
		model=Profile
		fields=['picture','user']

	def save(self):
		profile=Profile(picture=self.validated_data['picture'],user=self.validated_data['user'])
		profile.save()
		return profile