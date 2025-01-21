import 'package:flutter/material.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';
import 'package:suicide/utils/constants.dart';
import 'package:suicide/widgets/board/piece_widget.dart';

class BoardSquare extends StatelessWidget {
  final Position position;
  final Piece? piece;
  final bool isSelected;
  final bool isValidMove;
  final bool isForcedCapture;

  const BoardSquare({
    Key? key,
    required this.position,
    this.piece,
    this.isSelected = false,
    this.isValidMove = false,
    this.isForcedCapture = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightSquare = (position.x + position.y) % 2 == 0;

    Color getSquareColor() {
      if (isSelected) return GameConstants.SELECTED_SQUARE;
      if (isForcedCapture) return GameConstants.FORCED_CAPTURE;
      if (isValidMove) return GameConstants.VALID_MOVE;
      return isLightSquare
          ? GameConstants.LIGHT_SQUARE
          : GameConstants.DARK_SQUARE;
    }

    return Container(
      color: getSquareColor(),
      child: piece != null
          ? Draggable<Position>(
              data: position,
              feedback:
                  PieceWidget(piece: piece!, size: GameConstants.SQUARE_SIZE),
              childWhenDragging: Container(),
              child:
                  PieceWidget(piece: piece!, size: GameConstants.SQUARE_SIZE),
            )
          : null,
    );
  }
}
