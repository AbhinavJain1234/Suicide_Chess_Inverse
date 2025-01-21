// Create this new widget to handle async initialization
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suicide/providers/game_provider.dart';
import 'package:suicide/providers/move_provider.dart';
import 'package:suicide/screens/home_screen.dart';
import 'package:suicide/services/sound_service.dart';
import 'package:suicide/services/storage_service.dart';

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
              Provider<StorageService>(
                create: (_) => StorageService(snapshot.data!),
                dispose: (_, service) async {
                  // Any cleanup if needed
                },
              ),
              Provider<SoundService>(
                create: (_) => SoundService(),
              ),
              ChangeNotifierProxyProvider<StorageService, GameProvider>(
                create: (context) => GameProvider(
                  storageService: context.read<StorageService>(),
                  soundService: context.read<SoundService>(),
                ),
                update: (context, storage, previousGame) {
                  return previousGame ??
                      GameProvider(
                        storageService: storage,
                        soundService: context.read<SoundService>(),
                      );
                },
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suicide',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
