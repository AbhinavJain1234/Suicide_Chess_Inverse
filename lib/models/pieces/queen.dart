import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class Queen extends Piece {
  Queen(PieceColor color, Position position)
      : super(PieceType.queen, color, position);

  @override
  List<Position> getValidMoves(List<List<Piece?>> board) {
    List<Position> validMoves = [];
    final directions = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ];

    for (var direction in directions) {
      int dx = direction[0], dy = direction[1];
      int x = position.x + dx, y = position.y + dy;

      while (_isValidPosition(Position(x, y))) {
        if (board[y][x] == null) {
          validMoves.add(Position(x, y));
        } else {
          if (board[y][x]!.color != color) {
            validMoves.add(Position(x, y));
          }
          break;
        }
        x += dx;
        y += dy;
      }
    }

    return validMoves;
  }

  @override
  List<Position> getForcedCaptures(List<List<Piece?>> board) {
    return getValidMoves(board)
        .where((pos) =>
            board[pos.y][pos.x] != null && board[pos.y][pos.x]!.color != color)
        .toList();
  }

  @override
  bool canCapture(Position target, List<List<Piece?>> board) {
    return getForcedCaptures(board).contains(target);
  }
}

bool _isValidPosition(Position pos) {
  return pos.x >= 0 && pos.x < 8 && pos.y >= 0 && pos.y < 8;
}
