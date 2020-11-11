import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isVolume = sharedPreferences.getBool(Constant.chatBubbleVolumeState);
    if (isVolume == null || isVolume) {
    //  await flutterTts.speak(chatText);
    } else {
      await flutterTts.stop();
    }
  }
}
