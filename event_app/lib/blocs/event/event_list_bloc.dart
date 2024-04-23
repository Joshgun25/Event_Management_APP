import 'package:event_app/models/event.dart';
import 'package:event_app/services/event/event_service.dart';
import 'package:rxdart/rxdart.dart';


class EventListBloc{
  final EventService _eventService = EventService();
  final BehaviorSubject<List<Event>> _eventListDataBehaviorSubject =
  BehaviorSubject<List<Event>>();

  ValueStream<List<Event>> get eventListValueStream =>
      _eventListDataBehaviorSubject.stream;

  EventListBloc();


  void fetchEvents() async {
    try {
      List<Event> events = await _eventService.fetchEvents();
      _eventListDataBehaviorSubject.add(events);
    } catch (e) {
      // Handle error
      print('Failed to fetch events: $e');
    }
  }
}