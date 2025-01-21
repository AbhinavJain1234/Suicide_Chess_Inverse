import 'package:suicide/models/gameState.dart';
import 'package:suicide/models/move.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class MoveValidator {
  static bool isValidMove(GameState gameState, Move move) {
    // Check if move is within board bounds
    if (!move.from.isValid() || !move.to.isValid()) return false;

    final piece = gameState.board[move.from.y][move.from.x];
    if (piece == null) return false;

    // Check if it's the piece's turn
    if (piece.color != gameState.currentTurn) return false;

    // Get all valid moves for the piece
    final validMoves = piece.getValidMoves(gameState.board);
    if (!validMoves.contains(move.to)) return false;

    // Check for forced captures
    if (gameState.hasForcedMoves()) {
      return isForcedCapture(gameState, move);
    }

    return true;
  }

  static bool isForcedCapture(GameState gameState, Move move) {
    final piece = gameState.board[move.from.y][move.from.x];
    if (piece == null) return false;

    // Get all possible captures for the current player
    final forcedCaptures = getAllForcedCaptures(gameState);

    // If there are forced captures, the move must be one of them
    if (forcedCaptures.isNotEmpty) {
      return forcedCaptures.any((capture) =>
          capture.from == move.from &&
          capture.to == move.to &&
          capture.piece == piece);
    }

    return false;
  }

  static List<Move> getAllForcedCaptures(GameState gameState) {
    List<Move> forcedCaptures = [];

    // Check each piece of the current player for possible captures
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        final piece = gameState.board[y][x];
        if (piece?.color == gameState.currentTurn) {
          final captures = piece!.getForcedCaptures(gameState.board);
          forcedCaptures.addAll(captures.map((pos) => Move(
                from: piece.position,
                to: pos,
                piece: piece,
                capturedPiece: gameState.board[pos.y][pos.x],
                isForced: true,
              )));
        }
      }
    }

    return forcedCaptures;
  }

  // Helper method to check if a position contains an enemy piece
  static bool isEnemyPiece(
      GameState gameState, Position position, PieceColor color) {
    final piece = gameState.board[position.y][position.x];
    return piece != null && piece.color != color;
  }

  // Helper method to check if a position is empty
  static bool isEmpty(GameState gameState, Position position) {
    return gameState.board[position.y][position.x] == null;
  }
}
