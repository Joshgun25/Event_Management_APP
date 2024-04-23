import 'dart:convert';
import 'package:event_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService{
  final String apiUrl = getApiUrl();

  UserService();

  Future<List<User>> fetchAssignedUsers(int eventId) async{
    final response = await http.get(Uri.parse('$apiUrl/assigned_users/$eventId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load assigned users');
    }
  }

  Future<List<User>> fetchUnassignedUsers(int eventId) async{
    final response = await http.get(Uri.parse('$apiUrl/unassigned_users/$eventId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load unassigned users');
    }
  }

  Future<void> assignUserToEvent(int userId, int eventId) async {
    final Map<String, dynamic> requestData = {
      'user_id': userId.toString(),
      'event_id': eventId.toString(),
    };
    final http.Response response = await http.post(
      Uri.parse('$apiUrl/assign/'),
      body: requestData,
    );
    if (response.statusCode == 201) {
      print('User assigned to event successfully');
    } else {
      print('Failed to assign user to event: ${response.body}');
      throw Exception('Failed to assign user to event');
    }
  }

  Future<void> unassignUserFromEvent(int userId, int eventId) async {
    final Map<String, dynamic> requestData = {
      'user_id': userId.toString(),
      'event_id': eventId.toString(),
    };
    final http.Response response = await http.delete(
      Uri.parse('$apiUrl/unassign/'),
      body: requestData,
    );
    if (response.statusCode == 200) {
      print('User unassigned from event successfully');
    } else {
      print('Failed to unassign user from event: ${response.body}');
      throw Exception('Failed to unassign user from event');
    }
  }
}

String getApiUrl() {
  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000/api';
  }
  else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.fuchsia) {
    return 'http://127.0.0.1:8000/api';
  }
  else {
    return 'http://127.0.0.1:8000/api';
  }
}