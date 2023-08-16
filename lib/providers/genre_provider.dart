import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/ticketmaster_api.dart';
import 'package:http/http.dart' as http;

class GenreProvider with ChangeNotifier {
  String? _selectedGenre;
  List<String> _genres = [];
  List<String> selectedGenres = [];

  List<String> get genres => _genres;

  String? get selectedGenre => _selectedGenre;

  Future<void> fetchGenres() async {
    try {
      _genres = await TicketmasterApi().fetchGenres();
      notifyListeners();
    } catch (error) {
      if (error is http.ClientException) {
      } else if (error is FormatException) {}
      notifyListeners();
    }
  }

  void setGenres(List<String> genresList) {
    _genres = genresList;
    notifyListeners();
  }

  void setSelectedGenre(String? genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  Set<String> getUniqueGenres(List<EventModel> events) {
    Set<String> genres = {};
    for (var event in events) {
      genres.add(event.genre);
    }
    return genres;
  }

  void toggleGenreSelection(String genre) {
    if (selectedGenres.contains(genre)) {
      selectedGenres.remove(genre);
    } else {
      selectedGenres.add(genre);
    }

    notifyListeners();
  }

  bool isGenreSelected(String genre) {
    return selectedGenres.contains(genre);
  }
}
