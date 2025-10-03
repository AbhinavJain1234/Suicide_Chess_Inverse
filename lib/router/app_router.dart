import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suicide/screens/splash_screen.dart';
import 'package:suicide/screens/home_screen.dart';
import 'package:suicide/screens/game_modes_screen.dart';
import 'package:suicide/screens/game_screen.dart';
import 'package:suicide/screens/setting_screen.dart';
import 'package:suicide/screens/game_history_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String gameModes = '/home/game-modes';
  static const String game = '/home/game-modes/game';
  static const String settings = '/home/settings';
  static const String history = '/home/history';

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: _slideFromBottomTransition,
        ),
        routes: [
          GoRoute(
            path: 'game-modes',
            name: 'gameModes',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const GameModesScreen(),
              transitionsBuilder: _slideFromRightTransition,
            ),
            routes: [
              GoRoute(
                path: 'game',
                name: 'game',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const GameScreen(),
                  transitionsBuilder: _slideFromRightTransition,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const SettingScreen(),
              transitionsBuilder: _slideFromRightTransition,
            ),
          ),
          GoRoute(
            path: 'history',
            name: 'history',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const GameHistoryScreen(),
              transitionsBuilder: _slideFromRightTransition,
            ),
          ),
        ],
      ),
    ],
  );

  // Custom page transitions
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget _slideFromRightTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  static Widget _slideFromBottomTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
