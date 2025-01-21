import 'package:flutter/material.dart';
import 'package:suicide/screens/game_screen.dart';
import 'package:suicide/screens/setting_screen.dart';
import 'package:suicide/widgets/dialogs/rule_dialoge.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Suicide Chess',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen()),
                );
              },
              child: const Text('New Game'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => RulesDialog(),
                );
              },
              child: const Text('Rules'),
            ),
            const SizedBox(height: 20),
            // OutlinedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => SettingsScreen()),
            //     );
            //   },
            //   child: const Text('Settings'),
            // ),
          ],
        ),
      ),
    );
  }
}
