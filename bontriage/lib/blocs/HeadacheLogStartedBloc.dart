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
      currentUserHeadacheModel = CurrentUserHeadacheModel(
          userId: userProfileInfoData.userId,
          selectedDate: DateTime.now().toUtc().toIso8601String(),
          isOnGoing: true);
      await SignUpOnBoardProviders.db
          .insertUserCurrentHeadacheData(currentUserHeadacheModel);
    }

    return currentUserHeadacheModel;
  }
}
