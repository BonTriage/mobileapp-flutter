import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSecondStepModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';
import 'package:mobile/util/constant.dart';


class SignUpOnBoardFirstStepRepository{
  String url;

  Future<dynamic> serviceCall(String url, RequestMethod requestMethod) async{
    var client = http.Client();
    var album;
    try {
      var response = await NetworkService(url,requestMethod,_getPayload()).serviceCall();
      if(response is AppException){
        return response;
      }else{
        album = SignUpOnBoardSecondStepModel.fromJson(json.decode(response));
        LocalQuestionnaire localQuestionnaire = LocalQuestionnaire();
        localQuestionnaire.eventType = Constant.firstEventStep;
        localQuestionnaire.questionnaires = response;
        localQuestionnaire.selectedAnswers = "";
        SignUpOnBoardProviders.db.insertQuestionnaire(localQuestionnaire);
        return album;
      }
    }catch(Exception){
      return album;
    }
  }

  String _getPayload(){
    return jsonEncode(<String, String>{
      "event_type": "clinical_impression_short1", "mobile_user_id": "4214"
    });
  }
}
