import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:mobile/models/AddHeadacheLogModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';


class AddHeadacheLogRepository{
  String url;

  Future<dynamic> serviceCall(String url, RequestMethod requestMethod) async{
    var client = http.Client();
    var album;
    try {
      var response = await NetworkService(url,requestMethod,_getPayload()).serviceCall();
      if(response is AppException){
        return response;
      }else{
        album = AddHeadacheLogModel.fromJson(json.decode(response));
        return album;
      }
    }catch(Exception){
      return album;
    }
  }

  String _getPayload(){
    return jsonEncode(<String, String>{
      "event_type": "headache", "mobile_user_id": "4214"
    });
  }
}
