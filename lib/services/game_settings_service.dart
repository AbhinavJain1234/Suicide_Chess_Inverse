import 'package:shared_preferences/shared_preferences.dart';

class GameSettingsService {
  static const String _moveLimitKey = 'game_move_limit';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _showCoordinatesKey = 'show_coordinates';
  static const String _highlightLastMoveKey = 'highlight_last_move';

  // Default values
  static const int defaultMoveLimit = 30; // Total moves for both players
  static const bool defaultSoundEnabled = true;
  static const bool defaultVibrationEnabled = true;
  static const bool defaultShowCoordinates = false;
  static const bool defaultHighlightLastMove = true;

  static Future<int> getMoveLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_moveLimitKey) ?? defaultMoveLimit;
  }

  static Future<void> setMoveLimit(int limit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_moveLimitKey, limit);
  }

  static Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? defaultSoundEnabled;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  static Future<bool> getVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationEnabledKey) ?? defaultVibrationEnabled;
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, enabled);
  }

  static Future<bool> getShowCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showCoordinatesKey) ?? defaultShowCoordinates;
  }

  static Future<void> setShowCoordinates(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showCoordinatesKey, show);
  }

  static Future<bool> getHighlightLastMove() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_highlightLastMoveKey) ?? defaultHighlightLastMove;
  }

  static Future<void> setHighlightLastMove(bool highlight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highlightLastMoveKey, highlight);
  }

  static Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'moveLimit': await getMoveLimit(),
      'soundEnabled': await getSoundEnabled(),
      'vibrationEnabled': await getVibrationEnabled(),
      'showCoordinates': await getShowCoordinates(),
      'highlightLastMove': await getHighlightLastMove(),
    };
  }
}
