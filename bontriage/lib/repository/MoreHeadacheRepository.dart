import 'package:mobile/models/DeleteHeadacheResponseModel.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/util/constant.dart';

class MoreHeadacheRepository {
  Future<dynamic> deleteHeadacheServiceCall(String url, RequestMethod requestMethod) async {
    try {
      var response = await NetworkService(url, requestMethod, Constant.blankString).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return deleteHeadacheResponseModelFromJson(response);
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> callServiceForDiagnosticData(String url, RequestMethod requestMethod) async {
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return responseModelFromJson(response);
      }
    } catch (e) {
      return null;
    }
  }
}