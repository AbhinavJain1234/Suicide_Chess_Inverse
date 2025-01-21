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
      }
    } else {
      clearSelection();
    }

    notifyListeners();
  }

  void clearSelection() {
    _selectedPosition = null;
    _validMoves = [];
    _forcedCaptures = [];
    notifyListeners();
  }
}
