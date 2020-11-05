import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechRecognition {
  static final FlutterTts flutterTts = FlutterTts();

  static Future<void> speechToText(String chatText) async {



    await flutterTts.setLanguage("en-US");

    await flutterTts.setSpeechRate(1.0);

    await flutterTts.setVolume(1.0);

    await flutterTts.setPitch(1.0);

    await flutterTts.setSharedInstance(true);
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
    ]);
    await flutterTts.speak(chatText);
  }

  static Future<void> pauseSpeechToText(bool isStop, String chatText) async {
    if (isStop) {
      await flutterTts.stop();
    } else
      await speechToText(chatText);
  }
}
