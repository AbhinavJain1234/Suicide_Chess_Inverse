import 'package:flutter/material.dart';
import 'package:suicide/models/pieces.dart';

class GameOverDialog extends StatelessWidget {
  final PieceColor? winner;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const GameOverDialog({
    super.key,
    required this.winner,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String message;
    IconData iconData;
    Color iconColor;

    if (winner == null) {
      title = 'Game Draw!';
      message = 'The game ended in a draw.';
      iconData = Icons.handshake;
      iconColor = Colors.orange;
    } else if (winner == PieceColor.white) {
      title = 'White Wins!';
      message = 'Congratulations! White player wins the game.';
      iconData = Icons.emoji_events;
      iconColor = Colors.amber;
    } else {
      title = 'Black Wins!';
      message = 'Congratulations! Black player wins the game.';
      iconData = Icons.emoji_events;
      iconColor = Colors.amber;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Icon(
            iconData,
            size: 64,
            color: iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: onGoHome,
          child: const Text('Home'),
        ),
        FilledButton(
          onPressed: onPlayAgain,
          child: const Text('Play Again'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
