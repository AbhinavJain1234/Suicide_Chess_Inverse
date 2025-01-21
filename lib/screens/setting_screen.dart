import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suicide/providers/game_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Sound Effects'),
                value: true, // Connect to sound service
                onChanged: (value) {
                  // Toggle sound
                },
              ),
              ListTile(
                title: const Text('Theme'),
                trailing: DropdownButton<String>(
                  value: 'Classic',
                  items: ['Classic', 'Modern', 'Minimal'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Update theme
                  },
                ),
              ),
              ListTile(
                title: const Text('Reset Statistics'),
                trailing: IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () {
                    // Reset stats
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
