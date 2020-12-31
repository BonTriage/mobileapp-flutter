import 'package:mobile/models/CurrentUserHeadacheModel.dart';
import 'package:mobile/providers/SignUpOnBoardProviders.dart';

class HeadacheLogStartedBloc {
  Future<CurrentUserHeadacheModel>
      storeHeadacheDetailsIntoLocalDatabase() async {
    var userProfileInfoData =
        await SignUpOnBoardProviders.db.getLoggedInUserAllInformation();

    CurrentUserHeadacheModel currentUserHeadacheModel;

    if (userProfileInfoData != null)
      currentUserHeadacheModel = await SignUpOnBoardProviders.db
          .getUserCurrentHeadacheData(userProfileInfoData.userId);

    if (currentUserHeadacheModel == null && userProfileInfoData != null) {
      DateTime currentDateTime = DateTime.now();
      DateTime dateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, currentDateTime.hour, currentDateTime.minute, 0, 0, 0);
      currentUserHeadacheModel = CurrentUserHeadacheModel(
          userId: userProfileInfoData.userId,
          selectedDate: dateTime.toUtc().toIso8601String(),
          isOnGoing: true);
      await SignUpOnBoardProviders.db
          .insertUserCurrentHeadacheData(currentUserHeadacheModel);
    }

    return currentUserHeadacheModel;
  }
}
