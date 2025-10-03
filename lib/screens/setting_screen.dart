import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:suicide/providers/game_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedTheme = 'System';
  String _boardStyle = 'Classic';
  bool _showCoordinates = false;
  bool _highlightLastMove = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _loadSettings();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load settings from storage
    // setState(() {
    //   _soundEnabled = await StorageService.getBool('sound_enabled') ?? true;
    //   _selectedTheme = await StorageService.getString('theme') ?? 'System';
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 28,
                      ),
                      Expanded(
                        child: Text(
                          'Settings',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                ),
              ),
            ),

            // Settings List
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Consumer<GameProvider>(
                    builder: (context, gameProvider, child) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          // Audio Section
                          _buildSectionHeader('Audio & Feedback'),
                          _buildSettingCard(
                            children: [
                              _buildSwitchTile(
                                title: 'Sound Effects',
                                subtitle: 'Play sounds for moves and captures',
                                icon: Icons.volume_up,
                                value: _soundEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _soundEnabled = value;
                                  });
                                  // Save to storage
                                },
                              ),
                              const Divider(height: 1),
                              _buildSwitchTile(
                                title: 'Vibration',
                                subtitle: 'Haptic feedback for actions',
                                icon: Icons.vibration,
                                value: _vibrationEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _vibrationEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Appearance Section
                          _buildSectionHeader('Appearance'),
                          _buildSettingCard(
                            children: [
                              _buildDropdownTile(
                                title: 'Theme',
                                subtitle: 'Choose app appearance',
                                icon: Icons.palette,
                                value: _selectedTheme,
                                items: ['System', 'Light', 'Dark'],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTheme = value;
                                  });
                                },
                              ),
                              const Divider(height: 1),
                              _buildDropdownTile(
                                title: 'Board Style',
                                subtitle: 'Customize chess board look',
                                icon: Icons.grid_4x4,
                                value: _boardStyle,
                                items: ['Classic', 'Modern', 'Wood', 'Marble'],
                                onChanged: (value) {
                                  setState(() {
                                    _boardStyle = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Game Settings Section
                          _buildSectionHeader('Game Settings'),
                          _buildSettingCard(
                            children: [
                              _buildSwitchTile(
                                title: 'Show Coordinates',
                                subtitle:
                                    'Display board coordinates (a-h, 1-8)',
                                icon: Icons.grid_on,
                                value: _showCoordinates,
                                onChanged: (value) {
                                  setState(() {
                                    _showCoordinates = value;
                                  });
                                },
                              ),
                              const Divider(height: 1),
                              _buildSwitchTile(
                                title: 'Highlight Last Move',
                                subtitle: 'Show the previous move on board',
                                icon: Icons.highlight,
                                value: _highlightLastMove,
                                onChanged: (value) {
                                  setState(() {
                                    _highlightLastMove = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Data Section
                          _buildSectionHeader('Data'),
                          _buildSettingCard(
                            children: [
                              _buildActionTile(
                                title: 'Reset Statistics',
                                subtitle: 'Clear all game history and stats',
                                icon: Icons.restore,
                                iconColor: Colors.orange,
                                onTap: () => _showResetDialog(context),
                              ),
                              const Divider(height: 1),
                              _buildActionTile(
                                title: 'Export Game Data',
                                subtitle: 'Save your games to file',
                                icon: Icons.download,
                                iconColor: Colors.blue,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Export feature coming soon!')),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // About Section
                          _buildSectionHeader('About'),
                          _buildSettingCard(
                            children: [
                              _buildInfoTile(
                                title: 'Version',
                                subtitle: '1.0.0',
                                icon: Icons.info_outline,
                              ),
                              const Divider(height: 1),
                              _buildActionTile(
                                title: 'Rate the App',
                                subtitle: 'Help us improve with your feedback',
                                icon: Icons.star_rate,
                                iconColor: Colors.amber,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Thank you for your support!')),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Statistics'),
          content: const Text(
            'Are you sure you want to reset all game statistics? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Statistics reset successfully!')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
