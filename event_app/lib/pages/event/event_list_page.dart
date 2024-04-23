import 'package:event_app/blocs/event/event_bloc.dart';
import 'package:event_app/blocs/event/event_list_bloc.dart';
import 'package:event_app/models/event.dart';
import 'package:flutter/material.dart';

import 'event_details_page.dart';

class EventListPage extends StatefulWidget {
  final EventListBloc _bloc;

  EventListPage(this._bloc) : super();

  @override
  State<StatefulWidget> createState() {
    return EventListPageState(this._bloc);
  }
}

class EventListPageState extends State<EventListPage> {
  final EventListBloc _bloc;
  final EventBloc eventBloc = EventBloc();
  EventListPageState(this._bloc) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
      ),
      body: StreamBuilder<List<Event>>(
        stream: _bloc.eventListValueStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildEventItem(snapshot.data![index]);
              },
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

  Widget _buildEventItem(Event event) {
    return GestureDetector(
      onTap: () {
        eventBloc.fetchEvent(event.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(eventBloc),
          ),
        );
        // Navigate to event details page
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Event Image
            SizedBox(
              height: 150,
              child: Image.network(
                event.imageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            // Event Name
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Event Date
            Text(
              event.dateTime.toString(),
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
