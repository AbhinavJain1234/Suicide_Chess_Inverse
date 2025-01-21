import 'package:flutter/material.dart';
import 'package:suicide/models/gameState.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/utils/constants.dart';

class ScoreBoard extends StatelessWidget {
  final GameState gameState;

  const ScoreBoard({
    Key? key,
    required this.gameState,
  }) : super(key: key);

  int _calculateScore(PieceColor color) {
    // Calculate score based on captured pieces
    return gameState.capturedPieces[color]!
        .map((piece) => GameConstants.PIECE_VALUES[piece.type] ?? 0)
        .fold(0, (sum, value) => sum + value);
  }

  Widget _buildCapturedPieces(PieceColor color) {
    final capturedPieces = gameState.capturedPieces[color] ?? [];

    return Wrap(
      spacing: 4,
      children: capturedPieces.map((piece) => _buildPieceIcon(piece)).toList(),
    );
  }

  Widget _buildPieceIcon(Piece piece) {
    // You can replace these with actual piece icons or images
    final icons = {
      PieceType.pawn: '♟',
      PieceType.knight: '♞',
      PieceType.bishop: '♝',
      PieceType.rook: '♜',
      PieceType.queen: '♛',
      PieceType.king: '♚',
    };

    return Text(
      icons[piece.type] ?? '',
      style: TextStyle(
        fontSize: 20,
        color: piece.color == PieceColor.white ? Colors.white : Colors.black,
        shadows: [
          Shadow(
            color: Colors.black54,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final whiteScore = _calculateScore(PieceColor.white);
    final blackScore = _calculateScore(PieceColor.black);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPlayerScore('White', whiteScore, PieceColor.white),
              Text(
                'VS',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              _buildPlayerScore('Black', blackScore, PieceColor.black),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildCapturedPieces(PieceColor.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCapturedPieces(PieceColor.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String player, int score, PieceColor color) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                gameState.currentTurn == color ? Colors.blue : Colors.black87,
          ),
        ),
        Text(
          score.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
