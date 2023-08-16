import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event_model.dart';

class TicketmasterApi {
  Future<List<EventModel>> fetchEvents(
      {int page = 0, String query = '', String genre = ''}) async {
    var url =
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=rlVkxhEOD64VKjCkPlIJKbGCazvIs0Pg&size=50&page=$page';

    // var uri = Uri.http(BASEURL, 'discovery/v2/events.json',
    //     {'q': '', 'Pg&size': 50, 'apikey': API_KEY});

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<dynamic> eventList = data['_embedded']['events'];

      List<EventModel> events =
          eventList.map((eventJson) => EventModel.fromJson(eventJson)).toList();

      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<EventModel>> fetchInitialEvents() async {
    var url =
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=rlVkxhEOD64VKjCkPlIJKbGCazvIs0Pg';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<EventModel> events = (data['_embedded']['events'] as List)
          .map((e) => EventModel.fromJson(e))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load initial events');
    }
  }

  Future<List<EventModel>> fetchEventsByName(String query) async {
    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=rlVkxhEOD64VKjCkPlIJKbGCazvIs0Pg&keyword=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['_embedded'] != null) {
        List<EventModel> events = (data['_embedded']['events'] as List)
            .map((e) => EventModel.fromJson(e))
            .toList();
        return events;
      }
      return [];
    } else {
      throw Exception("Failed to fetch events by name.");
    }
  }

  Future<List<String>> fetchGenres() async {
    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/classifications.json?apikey=rlVkxhEOD64VKjCkPlIJKbGCazvIs0Pg');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<String> genres = [];

      if (data['_embedded'] != null &&
          data['_embedded']['classifications'] != null) {
        List<dynamic> classifications = data['_embedded']['classifications'];

        for (var classification in classifications) {
          var segment = classification['segment'];
          if (segment != null && segment['_embedded'] != null) {
            var genreList = segment['_embedded']['genres'];
            if (genreList != null) {
              for (var genre in genreList) {
                genres.add(genre['name']);
              }
            }
          }
        }

        return genres;
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch genres.");
    }
  }

  Future<List<EventModel>> fetchEventsByGenre(List<String> genres) async {
    final genreParam = genres.join(',');
    final url = Uri.parse(
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=rlVkxhEOD64VKjCkPlIJKbGCazvIs0Pg&classificationName=$genreParam');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['_embedded'] != null) {
        List<EventModel> events = (data['_embedded']['events'] as List)
            .map((e) => EventModel.fromJson(e))
            .toList();
        return events;
      }
      return [];
    } else {
      throw Exception("Failed to fetch events by genre.");
    }
  }
}
