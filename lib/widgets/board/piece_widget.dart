import 'package:flutter/material.dart';
import 'package:suicide/models/pieces.dart';
import 'package:suicide/utils/constants.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final double size;

  const PieceWidget({
    Key? key,
    required this.piece,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      '${GameConstants.PIECE_PATH}${piece.color.name}_${piece.type.name}.png',
      width: size,
      height: size,
    );
  }
}
