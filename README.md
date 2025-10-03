# Suicide Chess - Flutter Game

A modern, feature-rich implementation of Suicide Chess (also known as Anti-Chess or Losing Chess) built with Flutter. The objective is to lose all your pieces or be unable to move - the opposite of traditional chess!

## 🎯 Game Features

### Core Gameplay
- **Suicide Chess Rules**: Players must capture when possible, goal is to lose all pieces
- **Customizable Move Limits**: Default 30 total moves (configurable in settings)
- **Smart Win Detection**: Game ends when move limit reached or traditional win conditions met
- **Real-time Score Tracking**: Points based on captured pieces values

### Modern Features
- **🔊 Sound Effects**: Move and capture sounds
- **📱 Responsive Design**: Works on phones, tablets, and desktop
- **🎨 Material 3 UI**: Clean, modern interface without distracting gradients
- **📊 Game History**: Local storage of all completed games with statistics
- **⚙️ Customizable Settings**: Adjust move limits, sound, and display preferences
- **🏆 Winner Display**: Beautiful game over dialog with victory celebration

### Technical Features
- **🧭 Smart Navigation**: Proper back button handling with nested routes
- **💾 Local Storage**: SharedPreferences for game history and settings
- **🎵 Audio System**: AudioPlayers integration for sound effects
- **🔄 State Management**: Provider pattern for reactive UI updates

## 📱 Screenshots

### Game Screen
- Interactive chess board with piece movement
- Real-time move counter and remaining moves display
- Current player indicator with score tracking
- Captured pieces display

### Features Overview
- Home screen with game modes
- Settings screen for customization
- Game history with detailed statistics
- Game over dialog with winner announcement

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.5.0)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AbhinavJain1234/suicide.git
   cd suicide
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add Audio Files (Optional)**
   - Place `move.mp3` and `capture.mp3` in `assets/sounds/` folder
   - See `assets/sounds/README.md` for audio file requirements
   - Game works without sounds but audio enhances experience

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎮 How to Play

### Suicide Chess Rules
1. **Forced Captures**: If you can capture an opponent's piece, you MUST capture
2. **Goal**: Lose all your pieces or be unable to move
3. **Winning**: First player to lose all pieces wins
4. **Move Limit**: Games end after customizable move limit (default: 30 total moves)
5. **Scoring**: Points awarded based on captured piece values

### Game Controls
- **Tap to Move**: Tap piece, then tap destination square
- **Undo**: Use back arrow to undo last move
- **Reset**: Refresh button to start new game
- **Pause**: Pause button to halt timer
- **Settings**: Customize move limits, sound, and display options

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── models/                   # Data models
│   ├── gameState.dart       # Game state management
│   ├── move.dart            # Move representation
│   ├── pieces.dart          # Chess pieces logic
│   └── positions.dart       # Board position handling
├── providers/               # State management
│   ├── game_provider.dart   # Main game logic controller
│   └── move_provider.dart   # Move validation and history
├── screens/                 # UI screens
│   ├── home_screen.dart     # Main menu
│   ├── game_screen.dart     # Game board and controls
│   └── setting_screen.dart  # Settings configuration
├── services/                # Business logic services
│   ├── game_history_service.dart   # Local storage for games
│   ├── game_settings_service.dart  # Settings management
│   ├── sound_service.dart          # Audio playback
│   └── storage_service.dart        # Data persistence
├── utils/                   # Utilities and constants
│   ├── board_utils.dart     # Board helper functions
│   ├── constants.dart       # Game constants and values
│   └── move_validator.dart  # Move validation logic
├── widgets/                 # Reusable UI components
│   ├── board/              # Chess board components
│   ├── dialogs/            # Modal dialogs
│   └── game_control/       # Game control widgets
└── router/                 # Navigation configuration
    └── app_router.dart     # GoRouter setup
```

## 🔧 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.3.5    # Local storage
  audioplayers: ^6.1.0         # Sound effects
  provider: ^6.1.2             # State management
  go_router: ^14.2.7           # Navigation
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0        # Code quality
```

## ⚙️ Configuration

### Audio Setup
1. Create audio files for move and capture sounds
2. Place files in `assets/sounds/`:
   - `move.mp3` - Played when pieces move without capturing
   - `capture.mp3` - Played when pieces capture other pieces
3. Run `flutter clean && flutter pub get` to refresh assets

### Settings Customization
- **Move Limit**: Adjust total moves before game ends (default: 30)
- **Sound Effects**: Enable/disable audio feedback
- **Display Options**: Customize UI preferences

## 🧪 Testing

Run tests with:
```bash
flutter test
```

Run code analysis:
```bash
flutter analyze
```

## 📱 Building

### Android APK
```bash
flutter build apk --release
```

### iOS (requires macOS and Xcode)
```bash
flutter build ios --release
```


## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Chess.com for game rule references
- Material Design for UI inspiration
- Open source community for packages used

## 📞 Support

If you have any questions or issues:
- Open an issue on GitHub
- Check the documentation in the code


---

**Enjoy playing Suicide Chess! 🎉**

