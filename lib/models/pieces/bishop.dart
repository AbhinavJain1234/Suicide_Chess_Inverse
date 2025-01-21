import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class Bishop extends Piece {
  Bishop(PieceColor color, Position position)
      : super(PieceType.bishop, color, position);

  @override
  List<Position> getValidMoves(List<List<Piece?>> board) {
    List<Position> validMoves = [];
    final directions = [
      [-1, -1], [-1, 1], [1, -1], [1, 1] // Diagonal directions
    ];

    for (var direction in directions) {
      int dx = direction[0], dy = direction[1];
      int x = position.x + dx, y = position.y + dy;

      while (_isValidPosition(Position(x, y))) {
        if (board[x][y] == null) {
          validMoves.add(Position(x, y));
        } else {
          if (board[x][y]!.color != color) {
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
            board[pos.x][pos.y] != null && board[pos.x][pos.y]!.color != color)
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
