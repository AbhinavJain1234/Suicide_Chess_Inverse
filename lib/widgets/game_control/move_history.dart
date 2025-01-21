import 'package:flutter/material.dart';
import 'package:suicide/models/move.dart';

class MoveHistory extends StatelessWidget {
  final List<Move> moves;

  const MoveHistory({
    Key? key,
    required this.moves,
  }) : super(key: key);

  String _formatMove(Move move) {
    return '${move.from.x},${move.from.y} → ${move.to.x},${move.to.y}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Move History',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: moves.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${index + 1}. ${_formatMove(moves[index])}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
