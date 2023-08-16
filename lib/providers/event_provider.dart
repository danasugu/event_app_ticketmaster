import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../models/event_model.dart';
import '../services/ticketmaster_api.dart';

class EventProvider with ChangeNotifier {
  EventProvider() {
    fetchAllEvents();
  }
  List<EventModel> _events = [];
  List<EventModel> _filteredEvents = [];
  List<EventModel> get filteredEvents => _filteredEvents;
  final List<EventModel> _allEvents = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _searchQuery;

  List<EventModel> get events => _events;

  void setEvents(List<EventModel> events) {
    _events = events;
    notifyListeners();
  }

  void fetchInitialEvents() async {
    List<EventModel> events = await TicketmasterApi().fetchInitialEvents();
    setEvents(events);
  }

  void toggleWishlist(String id) {
    int index = _events.indexWhere((event) => event.id == id);
    if (index != -1) {
      _events[index] = EventModel(
        id: _events[index].id,
        name: _events[index].name,
        imageUrl: _events[index].imageUrl,
        startDate: _events[index].startDate,
        endDate: _events[index].endDate,
        info: _events[index].info,
        isInWishlist: !_events[index].isInWishlist,
        genre: _events[index].genre,
      );
      notifyListeners();
    }
  }

  void filterEvents(List<String> selectedGenres) {
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      _filteredEvents = _events
          .where((event) =>
              event.name.toLowerCase().contains(_searchQuery!.toLowerCase()))
          .toList();
    } else {
      _filteredEvents = [..._events];
    }

    if (selectedGenres.isNotEmpty) {
      _filteredEvents = _filteredEvents
          .where((event) => selectedGenres.contains(event.genre))
          .toList();
    }

    notifyListeners();
  }

  Future<void> fetchEventsByName(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Fetching events with query: $query');
      List<EventModel> events =
          await TicketmasterApi().fetchEventsByName(query);
      print('Fetched ${events.length} events.');
      setEvents(events);
    } catch (error) {
      print('Error fetching events by name: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchEventsByName(String query) async {
    List<EventModel> searchedEvents =
        await TicketmasterApi().fetchEventsByName(query);
    // Update your events list with the searched events
    setEvents(searchedEvents);
  }

  Future<void> fetchEventsByGenres(List<String> genres) async {
    List<EventModel> events =
        await TicketmasterApi().fetchEventsByGenre(genres);
    _events = events;
    notifyListeners();
  }

  Future<void> loadEvents(context) async {
    try {
      // Extract unique genres
      Set<String> uniqueGenres = {};

      for (var event in _events) {
        uniqueGenres.add(event.genre);
      }

      notifyListeners();
    } catch (error) {
      log("Error loading events: $error");
    }
  }

  Future<void> fetchAllEvents() async {
    try {
      _isLoading = true;
      final api = TicketmasterApi();
      _events = (await api.fetchEvents()).cast<EventModel>();
      _filteredEvents = [..._events];

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      rethrow;
    }
  }

  void filterEventsByName(String query) {
    _filteredEvents = _events
        .where(
            (event) => event.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void resetEvents() {
    _events = List.from(_allEvents);
    notifyListeners();
  }
}
