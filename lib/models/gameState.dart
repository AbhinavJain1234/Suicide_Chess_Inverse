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
  int halfMoveCount; // count of ply (half-moves) since start
  int maxHalfMoves; // maximum allowed half-moves (default 60 => 30 total moves)
  bool isFinished; // tracks if game is completely finished
  DateTime? gameStartTime;
  DateTime? gameEndTime;

  GameState({
    required this.board,
    this.currentTurn = PieceColor.white,
    List<Move>? moveHistory,
    Map<PieceColor, List<Piece>>? capturedPieces,
    this.isGameOver = false,
    this.winner,
    this.halfMoveCount = 0,
    this.maxHalfMoves = 60,
    this.isFinished = false,
    this.gameStartTime,
    this.gameEndTime,
  })  : moveHistory = moveHistory ?? [],
        capturedPieces = capturedPieces ??
            {
              PieceColor.white: [],
              PieceColor.black: [],
            };

  // Create a deep copy clone of the game state for undo snapshots
  GameState clone() {
    // Clone board
    List<List<Piece?>> newBoard = List.generate(
      8,
      (y) => List<Piece?>.filled(8, null),
    );

    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        final piece = board[x][y];
        if (piece != null) {
          // Create a new piece instance based on its runtime type
          Piece? cloned;
          switch (piece.type) {
            case PieceType.pawn:
              cloned = PieceFactory.createPawn(piece.color, piece.position);
              break;
            case PieceType.rook:
              cloned = PieceFactory.createRook(piece.color, piece.position);
              break;
            case PieceType.knight:
              cloned = PieceFactory.createKnight(piece.color, piece.position);
              break;
            case PieceType.bishop:
              cloned = PieceFactory.createBishop(piece.color, piece.position);
              break;
            case PieceType.queen:
              cloned = PieceFactory.createQueen(piece.color, piece.position);
              break;
            case PieceType.king:
              cloned = PieceFactory.createKing(piece.color, piece.position);
              break;
          }
          cloned.hasMoved = piece.hasMoved;
          cloned.position = Position(piece.position.x, piece.position.y);
          newBoard[x][y] = cloned;
        }
      }
    }

    // Clone captured pieces lists
    Map<PieceColor, List<Piece>> newCaptured = {
      PieceColor.white: [],
      PieceColor.black: [],
    };

    capturedPieces.forEach((color, list) {
      for (var p in list) {
        // create a lightweight clone keeping type and color
        final clone = PieceFactory.createByType(p.type, p.color, p.position);
        if (clone != null) newCaptured[color]!.add(clone);
      }
    });

    return GameState(
      board: newBoard,
      currentTurn: currentTurn,
      moveHistory: List.from(moveHistory),
      capturedPieces: newCaptured,
      isGameOver: isGameOver,
      winner: winner,
      halfMoveCount: halfMoveCount,
      maxHalfMoves: maxHalfMoves,
      isFinished: isFinished,
      gameStartTime: gameStartTime,
      gameEndTime: gameEndTime,
    );
  }

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
    halfMoveCount++;

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
          if (board[x][y]!.color == PieceColor.white) {
            whiteCount++;
          } else {
            blackCount++;
          }
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
