import 'package:event_app/services/event/event_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/event.dart';

class EventBloc{
  final EventService _eventService = EventService();
  final BehaviorSubject<Event> _eventDataBehaviorSubject = BehaviorSubject<Event>();

  ValueStream<Event> get eventValueStream => _eventDataBehaviorSubject;

  EventBloc();

  void fetchEvent(int eventId) async {
    try {
      Event event = await _eventService.fetchEventById(eventId);
      _eventDataBehaviorSubject.add(event);
    } catch (e) {
      // Handle error
      print('Failed to fetch event: $e');
    }
  }


}