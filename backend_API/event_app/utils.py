from django.core.mail import send_mail
from django.conf import settings

def send_event_notification_email(user_email, event_name, event_location, event_time):
    subject = f'You are assigned to the event: {event_name}'
    message = f'You are assigned to the event "{event_name}"\nDate & Time: {event_time}\nLocation: {event_location}'
    from_email = settings.EMAIL_HOST_USER 
    recipient_list = [user_email]

    send_mail(subject, message, from_email, recipient_list)