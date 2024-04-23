import 'package:event_app/blocs/user/user_list_bloc.dart';
import 'package:event_app/models/user.dart';
import 'package:event_app/services/user/user_service.dart';
import 'package:flutter/material.dart';

class AssignedUserListPage extends StatefulWidget {
  final UserListBloc _bloc;
  final int eventId;

  final UserService userService = UserService();

  AssignedUserListPage(this._bloc, this.eventId);

  @override
  State<StatefulWidget> createState() {
    return AssignedUserPageState(this._bloc, this.userService, this.eventId);
  }
}

class AssignedUserPageState extends State<AssignedUserListPage> {
  final UserListBloc _bloc;
  final UserService userService;
  final int eventId;

  AssignedUserPageState(this._bloc, this.userService, this.eventId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unassign User'),
      ),
      body: StreamBuilder<List<User>>(
        stream: _bloc.userListValueStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  leading:  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.email),
                  trailing: ElevatedButton(
                    onPressed: () {
                      userService.unassignUserFromEvent(user.id, eventId).then((response) {
                        _bloc.fetchAssignedUsers(eventId);
                      }).catchError((error) {
                        print(error);
                      });
                    },
                    child: const Text('Unassign'),
                  ),
                );
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
}
