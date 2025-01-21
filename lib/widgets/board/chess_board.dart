import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suicide/models/gameState.dart';
import 'package:suicide/models/positions.dart';
import 'package:suicide/providers/move_provider.dart';
import 'package:suicide/utils/constants.dart';
import 'package:suicide/widgets/board/board_square.dart';

class ChessBoard extends StatelessWidget {
  final GameState gameState;
  final Function(Position from, Position to) onMove;

  const ChessBoard({
    Key? key,
    required this.gameState,
    required this.onMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MoveProvider>(
      builder: (context, moveProvider, child) {
        return SizedBox(
          width: GameConstants.BOARD_SIZE * GameConstants.SQUARE_SIZE,
          height: GameConstants.BOARD_SIZE * GameConstants.SQUARE_SIZE,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GameConstants.BOARD_SIZE,
            ),
            itemCount: GameConstants.BOARD_SIZE * GameConstants.BOARD_SIZE,
            itemBuilder: (context, index) {
              final x = index % GameConstants.BOARD_SIZE;
              final y = index ~/ GameConstants.BOARD_SIZE;
              final position = Position(x, y);
              final piece = gameState.board[y][x];

              return DragTarget<Position>(
                onAccept: (fromPosition) {
                  onMove(fromPosition, position);
                },
                builder: (context, candidateData, rejectedData) {
                  return BoardSquare(
                    position: position,
                    piece: piece,
                    isSelected: position == moveProvider.selectedPosition,
                    isValidMove: moveProvider.validMoves.contains(position),
                    isForcedCapture:
                        moveProvider.forcedCaptures.contains(position),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
