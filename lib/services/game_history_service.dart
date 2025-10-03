import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum GameResult { whiteWins, blackWins, draw }

class GameRecord {
  final String id;
  final DateTime date;
  final String playerWhite;
  final String playerBlack;
  final String winner;
  final int moves;
  final Duration duration;
  final GameResult result;

  GameRecord({
    required this.id,
    required this.date,
    required this.playerWhite,
    required this.playerBlack,
    required this.winner,
    required this.moves,
    required this.duration,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'playerWhite': playerWhite,
      'playerBlack': playerBlack,
      'winner': winner,
      'moves': moves,
      'duration': duration.inSeconds,
      'result': result.index,
    };
  }

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      id: json['id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      playerWhite: json['playerWhite'],
      playerBlack: json['playerBlack'],
      winner: json['winner'],
      moves: json['moves'],
      duration: Duration(seconds: json['duration']),
      result: GameResult.values[json['result']],
    );
  }
}

class GameHistoryService {
  static const String _historyKey = 'game_history';
  static const String _statsKey = 'game_stats';

  static Future<List<GameRecord>> getGameHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);

    if (historyJson == null) return [];

    final List<dynamic> historyList = jsonDecode(historyJson);
    return historyList.map((json) => GameRecord.fromJson(json)).toList();
  }

  static Future<void> saveGameHistory(List<GameRecord> history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson =
        jsonEncode(history.map((game) => game.toJson()).toList());
    await prefs.setString(_historyKey, historyJson);
  }

  static Future<void> addGameRecord(GameRecord record) async {
    final history = await getGameHistory();
    history.insert(0, record); // Add to beginning for newest first

    // Keep only last 100 games to prevent storage bloat
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }

    await saveGameHistory(history);
    await _updateStats(record);
  }

  static Future<Map<String, int>> getGameStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);

    if (statsJson == null) {
      return {
        'totalGames': 0,
        'wins': 0,
        'losses': 0,
        'draws': 0,
      };
    }

    return Map<String, int>.from(jsonDecode(statsJson));
  }

  static Future<void> _updateStats(GameRecord record) async {
    final stats = await getGameStats();

    stats['totalGames'] = (stats['totalGames'] ?? 0) + 1;

    if (record.winner == 'You') {
      stats['wins'] = (stats['wins'] ?? 0) + 1;
    } else if (record.winner == 'Draw') {
      stats['draws'] = (stats['draws'] ?? 0) + 1;
    } else {
      stats['losses'] = (stats['losses'] ?? 0) + 1;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    await prefs.remove(_statsKey);
  }

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
