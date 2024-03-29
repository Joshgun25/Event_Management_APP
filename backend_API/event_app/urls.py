from django.urls import path
from . import views

urlpatterns = [
    path('events/', views.EventList.as_view(), name='event-list'),
    path('events/<int:pk>/', views.EventDetail.as_view(), name='event-detail'),
    path('assign/', views.AssignEvent.as_view(), name='assign-event'),
    path('unassign/', views.UnassignEvent.as_view(), name='unassign-event'),
    path('assigned_users/<int:event_id>/', views.AssignedUserList.as_view(), name='assigned_users'),
    path('unassigned_users/<int:event_id>/', views.UnassignedUserList.as_view(), name='unassigned_users'),
]