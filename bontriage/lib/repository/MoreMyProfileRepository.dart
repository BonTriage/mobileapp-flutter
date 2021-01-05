import 'package:http/http.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';

class MoreMyProfileRepository {

  Future<dynamic> myProfileServiceCall(String url, RequestMethod requestMethod) async {
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        List<ResponseModel> responseModelList = responseModelFromJson(response);
        if(responseModelList != null && responseModelList.length > 0)
          return responseModelList[0];
        else
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileInfoModel> getUserProfileInfoModel() async{
    return await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
  }
}