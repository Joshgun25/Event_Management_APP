import 'package:event_app/blocs/event/event_list_bloc.dart';
import 'package:event_app/pages/event/event_list_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final EventListBloc eventListBloc = EventListBloc();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    eventListBloc.fetchEvents();

    return MaterialApp(
      title: 'Event Management App',
      home: EventListPage(eventListBloc),
    );
  }
}