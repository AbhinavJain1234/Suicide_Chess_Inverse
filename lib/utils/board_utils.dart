import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class BoardUtils {
  static bool isSquareDark(Position position) {
    return (position.x + position.y) % 2 == 1;
  }

  static List<Position> getDiagonalMoves(
      Position start, List<List<Piece?>> board) {
    List<Position> moves = [];
    final directions = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1]
    ];

    for (final direction in directions) {
      var x = start.x + direction[0];
      var y = start.y + direction[1];

      while (x >= 0 && x < 8 && y >= 0 && y < 8) {
        final position = Position(x, y);
        final piece = board[y][x];

        if (piece == null) {
          moves.add(position);
        } else {
          moves.add(position); // Can capture in Suicide Chess
          break;
        }

        x += direction[0];
        y += direction[1];
      }
    }

    return moves;
  }

  static List<Position> getStraightMoves(
      Position start, List<List<Piece?>> board) {
    List<Position> moves = [];
    final directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ];

    for (final direction in directions) {
      var x = start.x + direction[0];
      var y = start.y + direction[1];

      while (x >= 0 && x < 8 && y >= 0 && y < 8) {
        final position = Position(x, y);
        final piece = board[y][x];

        if (piece == null) {
          moves.add(position);
        } else {
          moves.add(position); // Can capture in Suicide Chess
          break;
        }

        x += direction[0];
        y += direction[1];
      }
    }

    return moves;
  }
}
