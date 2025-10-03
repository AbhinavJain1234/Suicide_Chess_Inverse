import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class Knight extends Piece {
  Knight(PieceColor color, Position position)
      : super(PieceType.knight, color, position);

  @override
  List<Position> getValidMoves(List<List<Piece?>> board) {
    List<Position> validMoves = [];
    final moves = [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
      [2, -1],
      [2, 1]
    ];

    for (var move in moves) {
      int x = position.x + move[0];
      int y = position.y + move[1];
      Position newPos = Position(x, y);

      if (_isValidPosition(newPos)) {
        if (board[y][x] == null || board[y][x]!.color != color) {
          validMoves.add(newPos);
        }
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
