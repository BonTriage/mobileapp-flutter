import 'package:mobile/models/ForgotPasswordModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/NetworkService.dart';
import 'package:mobile/networking/RequestMethod.dart';

class OtpValidationRepository {
  Future<dynamic> otpVerifyServiceCall(String url, RequestMethod requestMethod) async {
    try {
      var response = await NetworkService.getRequest(url, requestMethod).serviceCall();
      if (response is AppException) {
        return response;
      } else {
        return forgotPasswordModelFromJson(response);
      }
    } catch (e) {
      return null;
    }
  }
}