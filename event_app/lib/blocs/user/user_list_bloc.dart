import 'package:event_app/services/user/user_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/user.dart';

class UserListBloc{
  final UserService _userService = UserService();
  final BehaviorSubject<List<User>> _userListDataBehaviorSubject =
  BehaviorSubject<List<User>>();

  ValueStream<List<User>> get userListValueStream =>
      _userListDataBehaviorSubject.stream;

  UserListBloc();


  void fetchAssignedUsers(int eventId) async {
    try {
      List<User> assignedUsers = await _userService.fetchAssignedUsers(eventId);
      _userListDataBehaviorSubject.add(assignedUsers);
    } catch (e) {
      // Handle error
      print('Failed to fetch assigned users: $e');
    }
  }

  void fetchUnassignedUsers(int eventId) async {
    try {
      List<User> unassignedUsers = await _userService.fetchUnassignedUsers(eventId);
      _userListDataBehaviorSubject.add(unassignedUsers);
    } catch (e) {
      // Handle error
      print('Failed to fetch unassigned users: $e');
    }
  }
}