import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class King extends Piece {
  King(PieceColor color, Position position)
      : super(PieceType.king, color, position);

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
      int x = position.x + direction[0];
      int y = position.y + direction[1];
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
