import 'dart:io';

import 'package:event_app/blocs/event/event_bloc.dart';
import 'package:event_app/blocs/user/user_list_bloc.dart';
import 'package:event_app/pages/event/user/assigned_user_list_page.dart';
import 'package:event_app/pages/event/user/unassigned_user_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


import '../../models/event.dart';

class EventDetailsPage extends StatefulWidget{
  final EventBloc _bloc;

  const EventDetailsPage(this._bloc) : super();

  @override
  State<StatefulWidget> createState() {
    return EventDetailsPageState(this._bloc);
  }
}

class EventDetailsPageState extends State<EventDetailsPage>{


  final EventBloc _bloc;
  final UserListBloc _userListBloc = UserListBloc();

  EventDetailsPageState(this._bloc) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: StreamBuilder<Event>(
        stream: _bloc.eventValueStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final event = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.network(
                      event.imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Event Date
                  Text(
                    'Date: ${event.dateTime.toString()}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Event Location
                  Text(
                    'Location: ${event.location}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Attendance: ${event.attendanceCount}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _userListBloc.fetchUnassignedUsers(event.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnassignedUserListPage(_userListBloc, event.id),
                        ),
                      ).then((value) => _bloc.fetchEvent(event.id));
                    },
                    child: const Text('Assign User'),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      _userListBloc.fetchAssignedUsers(event.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignedUserListPage(_userListBloc, event.id),
                        ),
                      ).then((value) => _bloc.fetchEvent(event.id));
                    },
                    child: const Text('Unassign User'),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      _shareEvent(event);
                    },
                    child: const Text('Share Event'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _shareEvent(Event event) async{
    final String eventName = event.name;
    final String eventLocation = event.location;
    final String imageUrl = event.imageUrl;

    final String shareText = 'Event: $eventName\nLocation: $eventLocation';
    final bytes = await readBytes(Uri.parse(imageUrl));
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/event_image.jpg';
    File(path).writeAsBytesSync(bytes);


    await Share.shareFiles([path], text: shareText, subject: eventName);
  }
}