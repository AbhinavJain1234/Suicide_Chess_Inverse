// Create this new widget to handle async initialization
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suicide/providers/game_provider.dart';
import 'package:suicide/providers/move_provider.dart';
import 'package:suicide/router/app_router.dart';
// storage and sound services are not used in the simplified provider

class AppInitializer extends StatelessWidget {
  final Widget child;

  const AppInitializer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<GameProvider>(
                create: (_) => GameProvider(),
              ),
              ChangeNotifierProvider<MoveProvider>(
                create: (_) => MoveProvider(),
              ),
            ],
            child: child,
          );
        }

        // Show loading screen while SharedPreferences initializes
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    AppInitializer(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Suicide Chess',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Follow device theme
      routerConfig: AppRouter.router,
    );
  }
}
