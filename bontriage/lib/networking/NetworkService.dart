
import 'dart:io';

import 'package:http/http.dart' as http;

import 'AppException.dart';
import 'RequestHeader.dart';
import 'RequestMethod.dart';

class NetworkService{
  String url;
  var requestMethod;
  var requestBody;

  NetworkService(this.url,this.requestMethod,this.requestBody);
  NetworkService.getRequest(this.url,this.requestMethod);

  Future<dynamic> serviceCall() async{
    var client = http.Client();
    http.Response response;
    try{
      if(requestMethod == RequestMethod.GET){
        response = await client.get(url,headers: RequestHeader().createRequestHeaders());
      }else if(requestMethod == RequestMethod.POST){
        response = await client.post(url,headers: RequestHeader().createRequestHeaders(),body: requestBody,);
      }
      return  getApiResponse(response);
    }on SocketException{
      return NoInternetConnection("Please connect to internet");
    }
  }

  dynamic getApiResponse(http.Response response){
    switch(response.statusCode){
      case 200:
      case 201:
        return response.body;
      case 400:
        return BadRequestException();
      case 401:
        return UnauthorisedException();
      case 404:
      case 500:
        return ServerResponseException();
      default:
        return FetchDataException();
    }
  }
}