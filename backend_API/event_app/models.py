from django.db import models

# User Model
class User(models.Model):
    email = models.EmailField(unique=True)
    avatar_url = models.URLField(max_length=100)

    def __str__(self):
        return self.email

# Event Model    
class Event(models.Model):
    name = models.CharField(max_length=100)
    date_time = models.DateTimeField(auto_now_add=True)
    location = models.CharField(max_length=200)
    image_url = models.URLField(max_length=100)

    def __str__(self):
        return self.name
    
# Attendance Model 
class Attendance(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    joined_time = models.DateTimeField(auto_now_add=True)
