import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple Favorites service backed by SharedPreferences.
/// Stores favorites as a set of ids (we use the image URL as id).
class FavoritesService {
  FavoritesService._internal();

  static final FavoritesService instance = FavoritesService._internal();

  final ValueNotifier<Set<String>> favorites = ValueNotifier<Set<String>>({});

  static const _prefsKey = 'favorites_v1';

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefsKey) ?? <String>[];
      favorites.value = Set<String>.from(list);
    } catch (_) {
      favorites.value = {};
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, favorites.value.toList());
    } catch (_) {
      // ignore
    }
  }

  bool isFavorite(String id) => favorites.value.contains(id);

  Future<void> toggle(String id) async {
    final s = Set<String>.from(favorites.value);
    if (s.contains(id)) {
      s.remove(id);
    } else {
      s.add(id);
    }
    favorites.value = s;
    await _save();
  }
}
