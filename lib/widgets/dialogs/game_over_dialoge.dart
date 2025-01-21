import 'package:flutter/material.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/utils/constants.dart';

class GameOverDialog extends StatelessWidget {
  final PieceColor winner;
  final VoidCallback onNewGame;

  const GameOverDialog({
    Key? key,
    required this.winner,
    required this.onNewGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(GameConstants.GAME_OVER),
      content: Text(
        winner == PieceColor.white
            ? GameConstants.WHITE_WINS
            : GameConstants.BLACK_WINS,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onNewGame();
          },
          child: Text('New Game'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
