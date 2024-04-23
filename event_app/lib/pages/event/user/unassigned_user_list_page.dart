import 'package:event_app/blocs/user/user_list_bloc.dart';
import 'package:event_app/models/user.dart';
import 'package:event_app/services/user/user_service.dart';
import 'package:flutter/material.dart';


class UnassignedUserListPage extends StatefulWidget {
  final UserListBloc _bloc;
  final int eventId;

  final UserService userService = UserService();

  UnassignedUserListPage(this._bloc, this.eventId);

  @override
  State<StatefulWidget> createState() {
    return UnassignedUserPageState(this._bloc, this.userService, this.eventId);
  }
}

class UnassignedUserPageState extends State<UnassignedUserListPage> {
  final UserListBloc _bloc;
  final UserService userService;
  final int eventId;
  bool _assigningUser = false;

  UnassignedUserPageState(this._bloc, this.userService, this.eventId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign User'),
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.email),
                  trailing: _assigningUser
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _assigningUser = true;
                      });
                      userService.assignUserToEvent(user.id, eventId).then((response) {
                        _bloc.fetchUnassignedUsers(eventId);
                        setState(() {
                          _assigningUser = false;
                        });
                      }).catchError((error) {
                        setState(() {
                          _assigningUser = false;
                        });
                        print(error);
                      });
                    },
                    child: const Text('Assign'),
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
