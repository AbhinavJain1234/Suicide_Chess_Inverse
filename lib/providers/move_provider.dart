import 'package:flutter/material.dart';
import 'package:suicide/models/gameState.dart';
import 'package:suicide/models/positions.dart';

class MoveProvider extends ChangeNotifier {
  Position? _selectedPosition;
  List<Position> _validMoves = [];
  List<Position> _forcedCaptures = [];

  Position? get selectedPosition => _selectedPosition;
  List<Position> get validMoves => _validMoves;
  List<Position> get forcedCaptures => _forcedCaptures;

  void selectPosition(Position position, GameState gameState) {
    final piece = gameState.board[position.y][position.x];

    if (piece?.color == gameState.currentTurn) {
      _selectedPosition = position;
      _validMoves = piece!.getValidMoves(gameState.board);
      _forcedCaptures = piece.getForcedCaptures(gameState.board);

      // In Suicide Chess, if there are forced captures, only show those
      if (gameState.hasForcedMoves()) {
        _validMoves = _forcedCaptures;

        // If selecting a piece that can't capture when captures are forced,
        // find and auto-select a piece that can capture
        if (_forcedCaptures.isEmpty) {
          _findAndSelectForcedCapturePiece(gameState);
        }
      }
    } else {
      clearSelection();
    }

    notifyListeners();
  }

  void _findAndSelectForcedCapturePiece(GameState gameState) {
    // Find the first piece that has forced captures
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        final piece = gameState.board[y][x];
        if (piece != null && piece.color == gameState.currentTurn) {
          final captures = piece.getForcedCaptures(gameState.board);
          if (captures.isNotEmpty) {
            _selectedPosition = Position(x, y);
            _validMoves = captures;
            _forcedCaptures = captures;
            return;
          }
        }
      }
    }
  }

  void clearSelection() {
    _selectedPosition = null;
    _validMoves = [];
    _forcedCaptures = [];
    notifyListeners();
  }
}
