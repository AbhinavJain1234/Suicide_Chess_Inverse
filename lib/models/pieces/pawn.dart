import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class Pawn extends Piece {
  Pawn(PieceColor color, Position position)
      : super(PieceType.pawn, color, position);

  @override
  List<Position> getValidMoves(List<List<Piece?>> board) {
    List<Position> validMoves = [];
    int direction = color == PieceColor.white ? -1 : 1;

    // Forward move
    Position forward = Position(position.x, position.y + direction);
    if (_isValidPosition(forward) && board[forward.x][forward.y] == null) {
      validMoves.add(forward);

      // Double move on first turn
      if (!hasMoved) {
        Position doubleForward =
            Position(position.x, position.y + 2 * direction);
        if (_isValidPosition(doubleForward) &&
            board[doubleForward.x][doubleForward.y] == null) {
          validMoves.add(doubleForward);
        }
      }
    }

    // Capture moves (diagonal)
    for (int dx in [-1, 1]) {
      Position capture = Position(position.x + dx, position.y + direction);
      if (_isValidPosition(capture) &&
          board[capture.x][capture.y] != null &&
          board[capture.x][capture.y]!.color != color) {
        validMoves.add(capture);
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
