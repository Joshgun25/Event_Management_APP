import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../../models/event.dart';

class EventService {
  final String apiUrl = getApiUrl();

  EventService();

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$apiUrl/events'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Event.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<Event> fetchEventById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/events/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Event.fromJson(jsonData);
    } else {
      throw Exception('Failed to load event');
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