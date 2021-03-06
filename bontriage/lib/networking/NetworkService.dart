
import 'dart:io';

import 'package:http/http.dart' as http;

import 'AppException.dart';
import 'RequestHeader.dart';
import 'RequestMethod.dart';

var client = http.Client();

class NetworkService{
  String url;
  var requestMethod;
  var requestBody;

  NetworkService(this.url,this.requestMethod,this.requestBody);
  NetworkService.getRequest(this.url,this.requestMethod);

  Future<dynamic> serviceCall() async {

    http.Response response;
    print('Url???$url');

    var dateTime = DateTime.now();
    try{
      if (requestMethod == RequestMethod.GET) {
        response = await client.get(Uri.parse(url), headers: RequestHeader().createRequestHeaders());
      } else if (requestMethod == RequestMethod.POST) {
        print('request body???$requestBody');
        response = await client.post(Uri.parse(url), headers: RequestHeader().createRequestHeaders(), body: requestBody,);
      } else if (requestMethod == RequestMethod.DELETE) {
        response = await client.delete(Uri.parse(url), headers: RequestHeader().createRequestHeaders());
      }
      print('TimeTaken????${DateTime.now().difference(dateTime).inMilliseconds}');
      return  getApiResponse(response);
    } on SocketException {
      return NoInternetConnection("Please connect to internet");
    } catch (e) {
      print(e);
    }

    //client.close();
  }

  dynamic getApiResponse(http.Response response){
    print('StatusCode????${response.statusCode}');
    switch(response.statusCode) {
      case 200:
      case 201:
      case 404:
      case 401:
        return response.body;
      case 400:
        return BadRequestException();
      case 500:
        return ServerResponseException();
      default:
        return FetchDataException();
    }
  }
}