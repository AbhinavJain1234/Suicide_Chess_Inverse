import 'package:suicide/models/pieces.dart';
import 'package:suicide/models/positions.dart';

class Move {
  final Position from;
  final Position to;
  final Piece piece;
  final Piece? capturedPiece;
  final bool isForced;

  Move({
    required this.from,
    required this.to,
    required this.piece,
    this.capturedPiece,
    this.isForced = false,
  });

  @override
  String toString() {
    return '${piece.type} from $from to $to${capturedPiece != null ? " captures ${capturedPiece!.type}" : ""}';
  }
}
