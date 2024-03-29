from rest_framework import serializers
from .models import User, Event, Attendance

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'avatar_url']

class EventSerializer(serializers.ModelSerializer):
    attendance_count = serializers.SerializerMethodField()

    class Meta:
        model = Event
        fields = ['id', 'name', 'date_time', 'location', 'image_url', 'attendance_count']

    def get_attendance_count(self, obj):
        return Attendance.objects.filter(event=obj).count()

class AttendanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attendance
        fields = ['id', 'user', 'event', 'joined_time']