import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suicide/models/gameState.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/pieces/pawn.dart';
import 'package:suicide/models/pieces/rook.dart';
import 'package:suicide/models/pieces/knight.dart';
import 'package:suicide/models/pieces/bishop.dart';
import 'package:suicide/models/pieces/queen.dart';
import 'package:suicide/models/pieces/king.dart';
import 'package:suicide/models/positions.dart';

class StorageService {
  static const String GAME_STATE_KEY = 'game_state';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Encode the board state to JSON
  List<List<Map<String, dynamic>?>> encodeBoardState(List<List<Piece?>> board) {
    return List.generate(8, (y) {
      return List.generate(8, (x) {
        final piece = board[y][x];
        if (piece == null) return null;
        return {
          'type': piece.runtimeType.toString(),
          'color': piece.color.toString(),
          'position': {
            'x': piece.position.x,
            'y': piece.position.y,
          },
        };
      });
    });
  }

  // Encode captured pieces to JSON
  Map<String, List<Map<String, dynamic>>> encodeCapturedPieces(
      Map<PieceColor, List<Piece>> capturedPieces) {
    return {
      PieceColor.white.toString(): capturedPieces[PieceColor.white]!
          .map((piece) => {
                'type': piece.runtimeType.toString(),
                'position': {
                  'x': piece.position.x,
                  'y': piece.position.y,
                },
              })
          .toList(),
      PieceColor.black.toString(): capturedPieces[PieceColor.black]!
          .map((piece) => {
                'type': piece.runtimeType.toString(),
                'position': {
                  'x': piece.position.x,
                  'y': piece.position.y,
                },
              })
          .toList(),
    };
  }

  // Decode the board state from JSON
  List<List<Piece?>> decodeBoardState(List<dynamic> boardJson) {
    return List.generate(8, (y) {
      return List.generate(8, (x) {
        if (boardJson[y][x] == null) return null;

        final pieceData = boardJson[y][x] as Map<String, dynamic>;
        final position = Position(
          pieceData['position']['x'] as int,
          pieceData['position']['y'] as int,
        );
        final color = decodePieceColor(pieceData['color']);

        return createPiece(pieceData['type'], color, position);
      });
    });
  }

  // Decode captured pieces from JSON
  Map<PieceColor, List<Piece>> decodeCapturedPieces(
      Map<String, dynamic> capturedJson) {
    return {
      PieceColor.white:
          (capturedJson[PieceColor.white.toString()] as List).map((pieceData) {
        final position = Position(
          pieceData['position']['x'] as int,
          pieceData['position']['y'] as int,
        );
        return createPiece(pieceData['type'], PieceColor.white, position);
      }).toList(),
      PieceColor.black:
          (capturedJson[PieceColor.black.toString()] as List).map((pieceData) {
        final position = Position(
          pieceData['position']['x'] as int,
          pieceData['position']['y'] as int,
        );
        return createPiece(pieceData['type'], PieceColor.black, position);
      }).toList(),
    };
  }

  // Helper method to decode PieceColor from string
  PieceColor decodePieceColor(String colorString) {
    return colorString.contains('white') ? PieceColor.white : PieceColor.black;
  }

  // Helper method to create piece instances
  Piece createPiece(String type, PieceColor color, Position position) {
    switch (type) {
      case 'Pawn':
        return Pawn(color, position);
      case 'Rook':
        return Rook(color, position);
      case 'Knight':
        return Knight(color, position);
      case 'Bishop':
        return Bishop(color, position);
      case 'Queen':
        return Queen(color, position);
      case 'King':
        return King(color, position);
      default:
        throw Exception('Unknown piece type: $type');
    }
  }

  Future<void> saveGameState(GameState state) async {
    final stateJson = jsonEncode({
      'board': encodeBoardState(state.board),
      'currentTurn': state.currentTurn.toString(),
      'capturedPieces': encodeCapturedPieces(state.capturedPieces),
      'isGameOver': state.isGameOver,
    });
    await _prefs.setString(GAME_STATE_KEY, stateJson);
  }

  Future<GameState?> loadGameState() async {
    final stateString = _prefs.getString(GAME_STATE_KEY);
    if (stateString == null) return null;

    final stateJson = jsonDecode(stateString);
    return GameState(
      board: decodeBoardState(stateJson['board']),
      currentTurn: decodePieceColor(stateJson['currentTurn']),
      capturedPieces: decodeCapturedPieces(stateJson['capturedPieces']),
      isGameOver: stateJson['isGameOver'],
    );
  }
}
