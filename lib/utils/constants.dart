import 'package:flutter/material.dart';
import 'package:suicide/models/pieces.dart';

class GameConstants {
  // Board dimensions
  static const int BOARD_SIZE = 8;
  static const double SQUARE_SIZE = 45.0;

  // Colors
  static const Color LIGHT_SQUARE = Color(0xFFEEEED2);
  static const Color DARK_SQUARE = Color(0xFF769656);
  static const Color SELECTED_SQUARE = Color(0xFFBFCA68);
  static const Color VALID_MOVE = Color(0x80BFCA68);
  static const Color FORCED_CAPTURE = Color(0x80FF6B6B);

  // Piece values (for scoring)
  static const Map<PieceType, int> PIECE_VALUES = {
    PieceType.pawn: 1,
    PieceType.knight: 3,
    PieceType.bishop: 3,
    PieceType.rook: 5,
    PieceType.queen: 9,
    PieceType.king: 0, // In Suicide Chess, king has no special value
  };

  // Asset paths
  static const String PIECE_PATH = 'assets/piece_svg/';
  static const String SOUNDS_PATH = 'assets/sounds/';

  // Game messages
  static const String GAME_OVER = 'Game Over!';
  static const String WHITE_WINS = 'White Wins!';
  static const String BLACK_WINS = 'Black Wins!';
  static const String DRAW = 'Draw!';

  // Rules text
  static const String RULES_TITLE = 'Suicide Chess Rules';
  static const String RULES_TEXT = '''
    1. All regular chess piece movements apply
    2. Capturing is mandatory when possible
    3. The goal is to lose all your pieces
    4. The king has no special value
    5. There is no check or checkmate
    6. The player who loses all pieces first wins
  ''';
}
