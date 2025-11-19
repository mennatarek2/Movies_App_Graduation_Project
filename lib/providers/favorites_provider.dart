import 'package:flutter/foundation.dart';
import 'package:movies_app_graduation_project/core/prefs_manager/prefs_manager.dart';
import 'dart:convert';

class FavoritesProvider with ChangeNotifier {
  final PrefsManager _prefsManager;
  static const String _keyFavorites = 'favorite_movies';

  Set<String> _favoriteMovieIds = {};

  FavoritesProvider(this._prefsManager) {
    _loadFavorites();
  }

  Set<String> get favoriteMovieIds => _favoriteMovieIds;

  bool isFavorite(String movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  /// Load favorites from local storage
  Future<void> _loadFavorites() async {
    try {
      final favoritesJson = _prefsManager.getString(_keyFavorites);
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = jsonDecode(favoritesJson);
        _favoriteMovieIds = favoritesList.map((id) => id.toString()).toSet();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Toggle favorite status for a movie
  Future<void> toggleFavorite(String movieId) async {
    try {
      if (_favoriteMovieIds.contains(movieId)) {
        _favoriteMovieIds.remove(movieId);
      } else {
        _favoriteMovieIds.add(movieId);
      }

      // Save to local storage
      final favoritesList = _favoriteMovieIds.toList();
      await _prefsManager.setString(_keyFavorites, jsonEncode(favoritesList));

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  /// Add movie to favorites
  Future<void> addFavorite(String movieId) async {
    if (!_favoriteMovieIds.contains(movieId)) {
      await toggleFavorite(movieId);
    }
  }

  /// Remove movie from favorites
  Future<void> removeFavorite(String movieId) async {
    if (_favoriteMovieIds.contains(movieId)) {
      await toggleFavorite(movieId);
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    _favoriteMovieIds.clear();
    await _prefsManager.remove(_keyFavorites);
    notifyListeners();
  }
}
