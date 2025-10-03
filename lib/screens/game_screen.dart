import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:suicide/providers/game_provider.dart';
import 'package:suicide/models/move.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/widgets/board/chess_board.dart';
import 'package:suicide/widgets/dialogs/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Check if game is over and show dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (gameProvider.gameState.isGameOver &&
              gameProvider.gameState.isFinished) {
            _showGameOverDialog(context, gameProvider);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Suicide Chess'),
            actions: [
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => gameProvider.undoLastMove(),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => gameProvider.resetGame(),
              ),
              IconButton(
                icon: Icon(
                    gameProvider.isGamePaused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  gameProvider.togglePause();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Score and move counter display
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'White',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          gameProvider.gameState.currentTurn ==
                                                  PieceColor.white
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                    ),
                                  ),
                                  Text(
                                    '${gameProvider.getScore(PieceColor.white)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Move ${(gameProvider.gameState.halfMoveCount ~/ 2) + 1}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    'Remaining: ${(gameProvider.gameState.maxHalfMoves - gameProvider.gameState.halfMoveCount) ~/ 2}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Black',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          gameProvider.gameState.currentTurn ==
                                                  PieceColor.black
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                    ),
                                  ),
                                  Text(
                                    '${gameProvider.getScore(PieceColor.black)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Chess board - centered and sized properly
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                            maxHeight: 400,
                          ),
                          child: ChessBoard(
                            gameState: gameProvider.gameState,
                            onMove: (from, to) {
                              if (!gameProvider.isGamePaused) {
                                final piece = gameProvider
                                    .gameState.board[from.y][from.x];
                                final targetPiece =
                                    gameProvider.gameState.board[to.y][to.x];

                                if (piece != null) {
                                  final move = Move(
                                    from: from,
                                    to: to,
                                    piece: piece,
                                    capturedPiece: targetPiece,
                                    isForced: targetPiece != null,
                                  );
                                  gameProvider.makeMove(move);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Captured pieces section
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Captured Pieces',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'White Lost:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Expanded(
                                          child: _buildCapturedPiecesDisplay(
                                            gameProvider.gameState
                                                        .capturedPieces[
                                                    PieceColor.white] ??
                                                [],
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Black Lost:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Expanded(
                                          child: _buildCapturedPiecesDisplay(
                                            gameProvider.gameState
                                                        .capturedPieces[
                                                    PieceColor.black] ??
                                                [],
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCapturedPiecesDisplay(
      List<Piece> capturedPieces, BuildContext context) {
    if (capturedPieces.isEmpty) {
      return const Center(
        child: Text(
          'None',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: capturedPieces
          .map((piece) => _buildCapturedPieceWidget(piece, context))
          .toList(),
    );
  }

  Widget _buildCapturedPieceWidget(Piece piece, BuildContext context) {
    final icons = {
      PieceType.pawn: piece.color == PieceColor.white ? '♙' : '♟',
      PieceType.knight: piece.color == PieceColor.white ? '♘' : '♞',
      PieceType.bishop: piece.color == PieceColor.white ? '♗' : '♝',
      PieceType.rook: piece.color == PieceColor.white ? '♖' : '♜',
      PieceType.queen: piece.color == PieceColor.white ? '♕' : '♛',
      PieceType.king: piece.color == PieceColor.white ? '♔' : '♚',
    };

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          icons[piece.type] ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        winner: gameProvider.gameState.winner,
        onPlayAgain: () {
          Navigator.of(context).pop();
          gameProvider.resetGame();
        },
        onGoHome: () {
          Navigator.of(context).pop();
          context.go('/home');
        },
      ),
    );
  }
}
