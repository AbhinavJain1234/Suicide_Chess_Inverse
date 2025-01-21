import 'package:flutter/material.dart';
import 'package:suicide/models/gameState.dart';
import 'package:suicide/models/move.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/pieces/pawn.dart';
import 'package:suicide/models/pieces/rook.dart';
import 'package:suicide/models/pieces/knight.dart';
import 'package:suicide/models/pieces/bishop.dart';
import 'package:suicide/models/pieces/queen.dart';
import 'package:suicide/models/pieces/king.dart';
import 'package:suicide/models/positions.dart';
import 'package:suicide/services/sound_service.dart';
import 'package:suicide/services/storage_service.dart';
import 'package:suicide/utils/move_validator.dart';

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  final StorageService _storageService;
  final SoundService _soundService;
  List<Move> _moveHistory = [];
  bool _isGamePaused = false;

  GameProvider({
    required StorageService storageService,
    required SoundService soundService,
  })  : _storageService = storageService,
        _soundService = soundService {
    _initializeGame();
  }

  GameState get gameState => _gameState;
  List<Move> get moveHistory => _moveHistory;
  bool get isGamePaused => _isGamePaused;

  // Initialize new game
  void _initializeGame() {
    _gameState = GameState(
      board: _createInitialBoard(),
      currentTurn: PieceColor.white,
      capturedPieces: {
        PieceColor.white: <Piece>[], // Initialize as List<Piece>
        PieceColor.black: <Piece>[], // Initialize as List<Piece>
      },
      isGameOver: false,
    );
    _moveHistory.clear();
    notifyListeners();
  }

  // Create initial board setup
  List<List<Piece?>> _createInitialBoard() {
    var board = List.generate(8, (_) => List<Piece?>.filled(8, null));

    // Initialize pawns
    for (int i = 0; i < 8; i++) {
      board[1][i] = Pawn(PieceColor.black, Position(i, 1));
      board[6][i] = Pawn(PieceColor.white, Position(i, 6));
    }

    // Initialize rooks
    board[0][0] = Rook(PieceColor.black, Position(0, 0));
    board[0][7] = Rook(PieceColor.black, Position(7, 0));
    board[7][0] = Rook(PieceColor.white, Position(0, 7));
    board[7][7] = Rook(PieceColor.white, Position(7, 7));

    // Initialize knights
    board[0][1] = Knight(PieceColor.black, Position(1, 0));
    board[0][6] = Knight(PieceColor.black, Position(6, 0));
    board[7][1] = Knight(PieceColor.white, Position(1, 7));
    board[7][6] = Knight(PieceColor.white, Position(6, 7));

    // Initialize bishops
    board[0][2] = Bishop(PieceColor.black, Position(2, 0));
    board[0][5] = Bishop(PieceColor.black, Position(5, 0));
    board[7][2] = Bishop(PieceColor.white, Position(2, 7));
    board[7][5] = Bishop(PieceColor.white, Position(5, 7));

    // Initialize queens
    board[0][3] = Queen(PieceColor.black, Position(3, 0));
    board[7][3] = Queen(PieceColor.white, Position(3, 7));

    // Initialize kings
    board[0][4] = King(PieceColor.black, Position(4, 0));
    board[7][4] = King(PieceColor.white, Position(4, 7));

    return board;
  }

  // Execute a move
  Future<void> makeMove(Move move) async {
    if (!MoveValidator.isValidMove(_gameState, move)) return;

    final piece = _gameState.board[move.from.y][move.from.x];
    final capturedPiece = _gameState.board[move.to.y][move.to.x];

    // Execute the move
    _gameState.board[move.to.y][move.to.x] = piece;
    _gameState.board[move.from.y][move.from.x] = null;
    if (piece != null) {
      piece.position = move.to;
    }

    // Handle capture - Fixed the capture handling
    if (capturedPiece != null) {
      // Add to the correct list based on the captured piece's color
      _gameState.capturedPieces[capturedPiece.color]!.add(capturedPiece);
      await _soundService.playCaptureSound();
    } else {
      await _soundService.playMoveSound();
    }

    _moveHistory.add(move);
    _checkWinCondition();

    if (!_gameState.isGameOver) {
      _gameState.currentTurn = _gameState.currentTurn == PieceColor.white
          ? PieceColor.black
          : PieceColor.white;
    }

    await _storageService.saveGameState(_gameState);
    notifyListeners();
  }

  // Check if the game is over
  void _checkWinCondition() {
    int whitePieces = 0;
    int blackPieces = 0;

    // Count remaining pieces
    for (var row in _gameState.board) {
      for (var piece in row) {
        if (piece != null) {
          if (piece.color == PieceColor.white) {
            whitePieces++;
          } else {
            blackPieces++;
          }
        }
      }
    }

    // Check win condition (remember in Suicide Chess, losing all pieces is winning)
    if (whitePieces == 0 || blackPieces == 0) {
      _gameState.isGameOver = true;
      _gameState.winner =
          whitePieces == 0 ? PieceColor.white : PieceColor.black;
    }
  }

  // Check if a player must make a capture
  bool hasForcedCaptures() {
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        final piece = _gameState.board[y][x];
        if (piece != null && piece.color == _gameState.currentTurn) {
          final captureMoves = getValidMovesForPiece(Position(x, y))
              .where(
                  (pos) => _gameState.board[pos.y][pos.x]?.color != piece.color)
              .toList();
          if (captureMoves.isNotEmpty) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Get all valid moves for a piece
  List<Position> getValidMovesForPiece(Position position) {
    final piece = _gameState.board[position.y][position.x];
    if (piece == null || piece.color != _gameState.currentTurn) {
      return [];
    }

    final allMoves = piece.getValidMoves(_gameState.board);

    // If there are captures available, only return capture moves
    if (hasForcedCaptures()) {
      return allMoves.where((pos) {
        final targetPiece = _gameState.board[pos.y][pos.x];
        return targetPiece != null && targetPiece.color != piece.color;
      }).toList();
    }

    return allMoves;
  }

  // Reset the game
  void resetGame() {
    _initializeGame();
  }

  // Toggle pause state
  void togglePause() {
    _isGamePaused = !_isGamePaused;
    notifyListeners();
  }

  // Undo last move (if possible)
  Future<void> undoLastMove() async {
    if (_moveHistory.isEmpty) return;

    // Load the last saved game state
    final previousState = await _storageService.loadGameState();
    if (previousState != null) {
      _gameState = previousState;
      _moveHistory.removeLast();
      notifyListeners();
    }
  }
}
