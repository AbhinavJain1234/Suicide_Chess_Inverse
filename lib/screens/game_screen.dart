import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suicide/providers/game_provider.dart';
import 'package:suicide/models/move.dart';
import 'package:suicide/widgets/board/chess_board.dart';
import 'package:suicide/widgets/game_control/move_history.dart';
import 'package:suicide/widgets/game_control/score_board.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Suicide Chess'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => gameProvider.resetGame(),
              ),
              IconButton(
                icon: Icon(
                    gameProvider.isGamePaused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  gameProvider.togglePause();
                  print(gameProvider.isGamePaused);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Score board
              // ScoreBoard(gameState: gameProvider.gameState),

              // Chess board
              Expanded(
                child: Center(
                  child: ChessBoard(
                      gameState: gameProvider.gameState,
                      onMove: (from, to) {
                        if (!gameProvider.isGamePaused) {
                          final piece =
                              gameProvider.gameState.board[from.y][from.x];
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
                      }),
                ),
              ),

              // Move history
              MoveHistory(moves: gameProvider.moveHistory),
            ],
          ),
        );
      },
    );
  }
}
