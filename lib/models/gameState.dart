import 'package:suicide/models/move.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class GameState {
  List<List<Piece?>> board;
  PieceColor currentTurn;
  List<Move> moveHistory;
  Map<PieceColor, List<Piece>> capturedPieces;
  bool isGameOver;
  PieceColor? winner;

  GameState({
    required this.board,
    this.currentTurn = PieceColor.white,
    List<Move>? moveHistory,
    Map<PieceColor, List<Piece>>? capturedPieces,
    this.isGameOver = false,
    this.winner,
  })  : moveHistory = moveHistory ?? [],
        capturedPieces = capturedPieces ??
            {
              PieceColor.white: [],
              PieceColor.black: [],
            };

  bool hasForcedMoves() {
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        Piece? piece = board[x][y];
        if (piece != null && piece.color == currentTurn) {
          if (piece.getForcedCaptures(board).isNotEmpty) {
            return true;
          }
        }
      }
    }
    return false;
  }

  List<Move> getValidMoves(Position position) {
    Piece? piece = board[position.x][position.y];
    if (piece == null || piece.color != currentTurn) return [];

    // In Suicide Chess, if there's a capture available, it must be taken
    if (hasForcedMoves()) {
      return piece
          .getForcedCaptures(board)
          .map((pos) => Move(
                from: position,
                to: pos,
                piece: piece,
                capturedPiece: board[pos.x][pos.y],
                isForced: true,
              ))
          .toList();
    }

    // If no captures are available, return all valid moves
    return piece
        .getValidMoves(board)
        .map((pos) => Move(
              from: position,
              to: pos,
              piece: piece,
              capturedPiece: board[pos.x][pos.y],
            ))
        .toList();
  }

  void makeMove(Move move) {
    // Update board
    board[move.from.x][move.from.y] = null;
    board[move.to.x][move.to.y] = move.piece;
    move.piece.position = move.to;
    move.piece.hasMoved = true;

    // Handle capture
    if (move.capturedPiece != null) {
      capturedPieces[move.capturedPiece!.color]!.add(move.capturedPiece!);
    }

    // Add to history
    moveHistory.add(move);

    // Switch turns
    currentTurn =
        currentTurn == PieceColor.white ? PieceColor.black : PieceColor.white;

    // Check game over conditions
    _checkGameOver();
  }

  void _checkGameOver() {
    // Game is over when one player has lost all pieces except the king
    int whiteCount = 0;
    int blackCount = 0;

    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        if (board[x][y] != null) {
          if (board[x][y]!.color == PieceColor.white)
            whiteCount++;
          else
            blackCount++;
        }
      }
    }

    if (whiteCount <= 1 || blackCount <= 1) {
      isGameOver = true;
      // In Suicide Chess, the player with fewer pieces wins
      if (whiteCount < blackCount) {
        winner = PieceColor.white;
      } else if (blackCount < whiteCount) {
        winner = PieceColor.black;
      }
      // If equal, it's a draw (winner remains null)
    }
  }
}
