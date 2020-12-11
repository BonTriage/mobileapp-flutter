import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'constant.dart';

class TextToSpeechRecognition {
  static final FlutterTts flutterTts = FlutterTts();

  static Future<void> speechToText(String chatText) async {
    await flutterTts.setLanguage("en-US");

    if (Platform.isAndroid) {
      // Android-specific code
      await flutterTts.setSpeechRate(0.95);
      await flutterTts.setPitch(1.0);
    } else if (Platform.isIOS) {
      // iOS-specific code
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setSharedInstance(true);

      await flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
      ]);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isVolume = sharedPreferences.getBool(Constant.chatBubbleVolumeState);
    if (isVolume == null || isVolume) {
      Future.delayed(Duration(milliseconds: 50), () {
        startSpeech(chatText);
      });
    } else {
        await flutterTts.stop();

    }
  }

  static void startSpeech(String chatText) async{
    await flutterTts.speak(chatText);
  }

  static void stopSpeech() async{
    await flutterTts.stop();
  }
}
