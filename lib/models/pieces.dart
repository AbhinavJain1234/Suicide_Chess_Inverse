import 'package:suicide/models/positions.dart';

enum PieceType { pawn, rook, knight, bishop, queen, king }

enum PieceColor { white, black }

abstract class Piece {
  final PieceType type;
  final PieceColor color;
  Position position;
  bool hasMoved = false;

  Piece(this.type, this.color, this.position);

  List<Position> getValidMoves(List<List<Piece?>> board);
  List<Position> getForcedCaptures(List<List<Piece?>> board);
  bool canCapture(Position target, List<List<Piece?>> board);

  bool _isValidPosition(Position pos) {
    return pos.x >= 0 && pos.x < 8 && pos.y >= 0 && pos.y < 8;
  }
}
