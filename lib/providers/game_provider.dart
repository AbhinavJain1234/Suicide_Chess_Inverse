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
import 'package:suicide/utils/move_validator.dart';
import 'package:suicide/utils/constants.dart';
import 'package:suicide/services/sound_service.dart';
import 'package:suicide/services/game_history_service.dart';
import 'package:suicide/services/game_settings_service.dart';

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  final List<GameState> _snapshots = [];
  final List<Move> _moveHistory = [];
  final SoundService _soundService = SoundService();
  bool _isGamePaused = false;

  GameProvider() {
    _initializeGame();
  }

  GameState get gameState => _gameState;
  List<Move> get moveHistory => _moveHistory;
  bool get isGamePaused => _isGamePaused;
  SoundService get soundService => _soundService;

  // Initialize new game
  void _initializeGame() async {
    final moveLimit = await GameSettingsService.getMoveLimit();
    final now = DateTime.now();

    _gameState = GameState(
      board: _createInitialBoard(),
      currentTurn: PieceColor.white,
      capturedPieces: {
        PieceColor.white: <Piece>[], // Initialize as List<Piece>
        PieceColor.black: <Piece>[], // Initialize as List<Piece>
      },
      isGameOver: false,
      maxHalfMoves: moveLimit,
      gameStartTime: now,
    );
    _moveHistory.clear();
    _snapshots.clear();
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
    // Snapshot current state for undo
    _snapshots.add(_gameState.clone());

    final piece = _gameState.board[move.from.y][move.from.x];
    final capturedPiece = _gameState.board[move.to.y][move.to.x];

    // Execute the move
    _gameState.board[move.to.y][move.to.x] = piece;
    _gameState.board[move.from.y][move.from.x] = null;
    if (piece != null) {
      piece.position = move.to;
      piece.hasMoved = true;
    }

    // Handle capture - attribute score to owner of captured piece
    if (capturedPiece != null) {
      _gameState.capturedPieces[capturedPiece.color]!.add(capturedPiece);
      // Play capture sound
      _soundService.playCaptureSound();
    } else {
      // Play move sound
      _soundService.playMoveSound();
    }

    _moveHistory.add(move);
    _gameState.halfMoveCount++;

    // Check game over and move limit
    _checkWinCondition();
    if (!_gameState.isGameOver &&
        _gameState.halfMoveCount >= _gameState.maxHalfMoves) {
      // Game ends due to move limit; decide winner by score
      final whiteScore = _calculateScore(PieceColor.white);
      final blackScore = _calculateScore(PieceColor.black);
      if (whiteScore > blackScore) {
        _gameState.winner = PieceColor.white;
      } else if (blackScore > whiteScore) {
        _gameState.winner = PieceColor.black;
      } else {
        _gameState.winner = null; // draw
      }
      _gameState.isGameOver = true;
    }

    // If game is over, mark as finished and save to history
    if (_gameState.isGameOver) {
      _gameState.isFinished = true;
      _gameState.gameEndTime = DateTime.now();
      await _saveGameToHistory();
    }

    if (!_gameState.isGameOver) {
      _gameState.currentTurn = _gameState.currentTurn == PieceColor.white
          ? PieceColor.black
          : PieceColor.white;
    }

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

    // Check win condition (player with zero pieces loses and opponent wins)
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
    if (_snapshots.isEmpty) return;
    final previous = _snapshots.removeLast();
    _gameState = previous;
    if (_moveHistory.isNotEmpty) _moveHistory.removeLast();
    notifyListeners();
  }

  int _calculateScore(PieceColor color) {
    return _gameState.capturedPieces[color]!
        .map((piece) => GameConstants.PIECE_VALUES[piece.type] ?? 0)
        .fold(0, (sum, v) => sum + v);
  }

  // Public method to get score
  int getScore(PieceColor color) {
    return _calculateScore(color);
  }

  // Save completed game to history
  Future<void> _saveGameToHistory() async {
    if (!_gameState.isGameOver || _gameState.gameStartTime == null) return;

    final duration = _gameState.gameEndTime != null
        ? _gameState.gameEndTime!.difference(_gameState.gameStartTime!)
        : Duration.zero;

    GameResult result;
    String winner;

    if (_gameState.winner == PieceColor.white) {
      result = GameResult.whiteWins;
      winner = 'White';
    } else if (_gameState.winner == PieceColor.black) {
      result = GameResult.blackWins;
      winner = 'Black';
    } else {
      result = GameResult.draw;
      winner = 'Draw';
    }

    final gameRecord = GameRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _gameState.gameStartTime!,
      playerWhite: 'Player', // Default player name
      playerBlack: 'Computer', // Default player name
      winner: winner,
      moves: _moveHistory.length,
      duration: duration,
      result: result,
    );

    await GameHistoryService.addGameRecord(gameRecord);
  }
}
