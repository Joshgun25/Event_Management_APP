from django.shortcuts import render
from rest_framework import generics
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

from .models import Event, User, Attendance
from .serializers import UserSerializer, EventSerializer, AttendanceSerializer
from .utils import send_event_notification_email


# Event Listing method
class EventList(generics.ListAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer 

# Event Detail method
class EventDetail(generics.RetrieveAPIView):
    serializer_class = EventSerializer

    def get_queryset(self):
        event_id = self.kwargs.get('pk') 
        return Event.objects.filter(pk=event_id)  

# Assign User to Event method
class AssignEvent(generics.CreateAPIView):
    serializer_class = AttendanceSerializer

    def create(self, request, *args, **kwargs):
        user_id = request.data.get('user_id')
        event_id = request.data.get('event_id')

        if not user_id or not event_id:
            return Response({'error': 'User ID and Event ID must be provided.'}, status=400)

        user = get_object_or_404(User, pk=user_id)
        event = get_object_or_404(Event, pk=event_id)
        try:
            attendance = Attendance.objects.get(user=user, event=event)
            return Response({'error': 'User is already assigned to this event.'}, status=400)
        except Attendance.DoesNotExist:
            serializer = self.get_serializer(data={'user': user_id, 'event': event_id})
            serializer.is_valid(raise_exception=True)
            serializer.save()
            send_event_notification_email(user.email, event.name, event.location, event.date_time)
            return Response({'message': 'Event assigned to user successfully.'}, status=201)

# Unassign User from Event method
class UnassignEvent(generics.DestroyAPIView):
    def destroy(self, request, *args, **kwargs):
        user_id = request.data.get('user_id')
        event_id = request.data.get('event_id')

        if not user_id or not event_id:
            return Response({'error': 'User ID and Event ID must be provided.'}, status=400)

        user = get_object_or_404(User, pk=user_id)
        event = get_object_or_404(Event, pk=event_id)

        try:
            attendance = Attendance.objects.get(user=user, event=event)
            attendance.delete()
            return Response({'message': 'User unassigned from event successfully.'}, status=200)
        except Attendance.DoesNotExist:
            return Response({'error': 'Attendance record does not exist.'}, status=404)
        
# Fetch User list who is assigned to event
class AssignedUserList(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        event_id = self.kwargs['event_id']
        assigned_users = User.objects.filter(attendance__event_id=event_id)
        return assigned_users
        
# Fetch User list who is Not assigned to event
class UnassignedUserList(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        event_id = self.kwargs['event_id']
        assigned_users = User.objects.exclude(attendance__event_id=event_id)
        return assigned_users
