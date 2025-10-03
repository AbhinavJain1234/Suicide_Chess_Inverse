import 'package:suicide/models/positions.dart';
import 'package:suicide/models/pieces/pawn.dart';
import 'package:suicide/models/pieces/rook.dart';
import 'package:suicide/models/pieces/knight.dart';
import 'package:suicide/models/pieces/bishop.dart';
import 'package:suicide/models/pieces/queen.dart';
import 'package:suicide/models/pieces/king.dart';

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

// Lightweight factory to create concrete piece instances for cloning
class PieceFactory {
  static Piece? createByType(PieceType type, PieceColor color, Position pos) {
    switch (type) {
      case PieceType.pawn:
        return Pawn(color, Position(pos.x, pos.y));
      case PieceType.rook:
        return Rook(color, Position(pos.x, pos.y));
      case PieceType.knight:
        return Knight(color, Position(pos.x, pos.y));
      case PieceType.bishop:
        return Bishop(color, Position(pos.x, pos.y));
      case PieceType.queen:
        return Queen(color, Position(pos.x, pos.y));
      case PieceType.king:
        return King(color, Position(pos.x, pos.y));
    }
  }

  static Pawn createPawn(PieceColor color, Position pos) =>
      Pawn(color, Position(pos.x, pos.y));
  static Rook createRook(PieceColor color, Position pos) =>
      Rook(color, Position(pos.x, pos.y));
  static Knight createKnight(PieceColor color, Position pos) =>
      Knight(color, Position(pos.x, pos.y));
  static Bishop createBishop(PieceColor color, Position pos) =>
      Bishop(color, Position(pos.x, pos.y));
  static Queen createQueen(PieceColor color, Position pos) =>
      Queen(color, Position(pos.x, pos.y));
  static King createKing(PieceColor color, Position pos) =>
      King(color, Position(pos.x, pos.y));
}
