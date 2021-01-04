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
        return userProfileInfoModelFromJson(response);
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserProfileInfoModel> getUserProfileInfoModel() async{
    return await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();
  }
}