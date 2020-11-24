import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';

class HeadacheLogStartedBloc {

  Future<CurrentUserHeadacheModel> storeHeadacheDetailsIntoLocalDatabase() async{
    var userProfileInfoData = await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if(userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db.getUserCurrentHeadacheData(userProfileInfoData.userId);

    if(currentUserHeadacheModel == null && userProfileInfoData != null) {
      await SignUpOnBoardProviders.db.insertUserCurrentHeadacheData(CurrentUserHeadacheModel(userId: userProfileInfoData.userId, selectedDate: /*DateTime.now()*/DateTime.parse('2020-11-20 14:54:12.954').toUtc().toIso8601String(), isOnGoing: true));
    }

    return currentUserHeadacheModel;
  }
}