import 'package:flutter/material.dart';
import 'package:suicide/utils/constants.dart';

class RulesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(GameConstants.RULES_TITLE),
      content: SingleChildScrollView(
        child: Text(GameConstants.RULES_TEXT),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Got it!'),
        ),
      ],
    );
  }
}
