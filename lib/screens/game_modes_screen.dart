import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suicide/router/app_router.dart';

class GameModesScreen extends StatefulWidget {
  const GameModesScreen({super.key});

  @override
  State<GameModesScreen> createState() => _GameModesScreenState();
}

class _GameModesScreenState extends State<GameModesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for each game mode
    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeInOut,
        ),
      ));
    });

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 28,
                    ),
                    Expanded(
                      child: Text(
                        'Choose Game Mode',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Local Game Mode
                    _buildGameModeCard(
                      index: 0,
                      title: 'Local Game',
                      subtitle: 'Play against a friend on this device',
                      icon: Icons.people,
                      gradient: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      onTap: () => context.go(AppRouter.game),
                    ),

                    const SizedBox(height: 20),

                    // AI Game Mode
                    _buildGameModeCard(
                      index: 1,
                      title: 'Play vs AI',
                      subtitle: 'Challenge the computer opponent',
                      icon: Icons.smart_toy,
                      gradient: [
                        Colors.purple,
                        Colors.deepPurple,
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('AI mode coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      isComingSoon: true,
                    ),

                    const SizedBox(height: 20),

                    // Online Game Mode
                    _buildGameModeCard(
                      index: 2,
                      title: 'Online Game',
                      subtitle: 'Play with friends online',
                      icon: Icons.public,
                      gradient: [
                        Colors.green,
                        Colors.teal,
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Online mode coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      isComingSoon: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameModeCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isComingSoon ? Colors.grey.shade400 : gradient.first,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isComingSoon ? Colors.grey : gradient.first)
                      .withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (isComingSoon) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Soon',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
