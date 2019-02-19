import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  static TTSHelper _instance = null;

  FlutterTts _tts;

  TTSHelper._internal() {
    _tts = FlutterTts();
  }

  initState() async {
    await _tts.setLanguage("de-DE");
  }

  factory TTSHelper() {
    if (_instance == null) {
      _instance = TTSHelper._internal();
    }
    return _instance;
  }

  Future speak(String text) async {
    await _tts.speak(text);
  }
}