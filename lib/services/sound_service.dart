import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  Future<void> playMoveSound() async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/move.mp3'));
    }
  }

  Future<void> playCaptureSound() async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/capture.mp3'));
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
  }
}
