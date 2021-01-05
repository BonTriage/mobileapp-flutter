import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreMyProfileBloc.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/models/UserProfileInfoModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

import 'NetworkErrorScreen.dart';

class MoreMyProfileScreen extends StatefulWidget {
  final Function(BuildContext, String, dynamic) onPush;
  final Function(String) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;

  const MoreMyProfileScreen({Key key, this.onPush, this.openActionSheetCallback, this.showApiLoaderCallback})
      : super(key: key);

  @override
  _MoreMyProfileScreenState createState() => _MoreMyProfileScreenState();
}

class _MoreMyProfileScreenState extends State<MoreMyProfileScreen> {

  MoreMyProfileBloc _moreMyProfileBloc;
  //List<SelectedAnswers> _profileSelectedAnswerList;

  @override
  void initState() {
    super.initState();
    _moreMyProfileBloc = MoreMyProfileBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _moreMyProfileBloc.initNetworkStreamController();
      widget.showApiLoaderCallback(_moreMyProfileBloc.networkStream, () {
        _moreMyProfileBloc.enterSomeDummyData();
        _moreMyProfileBloc.fetchMyProfileData();
      });
      _moreMyProfileBloc.fetchMyProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Constant.moreBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Image(
                            width: 16,
                            height: 16,
                            image: AssetImage(Constant.leftArrow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Constant.myProfile,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostRegular),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  StreamBuilder(
                    stream: _moreMyProfileBloc.myProfileStream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData && snapshot.data is ResponseModel && snapshot.data != null) {
                        /*ResponseModel responseModel = snapshot.data;
                        MobileEventDetails firstNameMobileEventDetails = responseModel.mobileEventDetails.firstWhere((element) => element.questionTag == Constant.profileFirstNameTag, orElse: () => null);
                        MobileEventDetails ageMobileEventDetails = responseModel.mobileEventDetails.firstWhere((element) => element.questionTag == Constant.profileAgeTag, orElse: () => null);
                        MobileEventDetails sexMobileEventDetails = responseModel.mobileEventDetails.firstWhere((element) => element.questionTag == Constant.profileSexTag, orElse: () => null);
                        MobileEventDetails genderMobileEventDetails = responseModel.mobileEventDetails.firstWhere((element) => element.questionTag == Constant.profileGenderTag, orElse: () => null);*/
                        SelectedAnswers firstNameSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileFirstNameTag, orElse: () => null);
                        SelectedAnswers ageSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileAgeTag, orElse: () => null);
                        SelectedAnswers sexSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileSexTag, orElse: () => null);
                        SelectedAnswers genderSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileGenderTag, orElse: () => null);
                        //_initSelectedAnswer(firstNameMobileEventDetails, ageMobileEventDetails, sexMobileEventDetails, genderMobileEventDetails);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.moreBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MoreSection(
                                    currentTag: Constant.profileFirstNameTag,
                                    text: Constant.name,
                                    moreStatus: firstNameSelectedAnswer?.answer ?? '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                    selectedAnswerList: _moreMyProfileBloc.profileSelectedAnswerList,
                                  ),
                                  MoreSection(
                                    currentTag: Constant.profileAgeTag,
                                    text: Constant.age,
                                    moreStatus: ageSelectedAnswer?.answer ?? '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                    selectedAnswerList: _moreMyProfileBloc.profileSelectedAnswerList,
                                  ),
                                  MoreSection(
                                    currentTag: Constant.profileGenderTag,
                                    text: Constant.gender,
                                    moreStatus: genderSelectedAnswer?.answer ?? '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                    selectedAnswerList: _moreMyProfileBloc.profileSelectedAnswerList,
                                  ),
                                  MoreSection(
                                    currentTag: Constant.profileSexTag,
                                    text: Constant.sex,
                                    moreStatus: sexSelectedAnswer?.answer ?? '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                    selectedAnswerList: _moreMyProfileBloc.profileSelectedAnswerList,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Constant.reCompleteInitialAssessment,
                                        style: TextStyle(
                                            color: Constant
                                                .addCustomNotificationTextColor,
                                            fontSize: 16,
                                            fontFamily: Constant.jostRegular),
                                      ),
                                      Image(
                                        width: 16,
                                        height: 16,
                                        image: AssetImage(Constant.rightArrow),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Constant.locationServiceGreen,
                                    thickness: 1,
                                    height: 30,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      Constant.save,
                                      style: TextStyle(
                                          color: Constant.locationServiceGreen,
                                          fontSize: 16,
                                          fontFamily: Constant.jostMedium
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                Constant.headacheTypes,
                                style: TextStyle(
                                    color: Constant.addCustomNotificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostMedium
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.moreBackgroundColor,
                              ),
                              child: Column(
                                children: [
                                  MoreSection(
                                    currentTag: Constant.headacheType,
                                    text: Constant.headacheType,
                                    moreStatus: '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                  ),
                                  MoreSection(
                                    currentTag: Constant.headacheType,
                                    text: Constant.headacheType,
                                    moreStatus: '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                  ),
                                  MoreSection(
                                    currentTag: Constant.headacheType,
                                    text: Constant.headacheType,
                                    moreStatus: '',
                                    isShowDivider: false,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.moreBackgroundColor,
                              ),
                              child: Column(
                                children: [
                                  MoreSection(
                                    currentTag: Constant.myTriggers,
                                    text: Constant.myTriggers,
                                    moreStatus: '',
                                    isShowDivider: true,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                  ),
                                  MoreSection(
                                    currentTag: Constant.myMedications,
                                    text: Constant.myMedications,
                                    moreStatus: '',
                                    isShowDivider: false,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        );
                      } /*else if (snapshot.hasError) {
                        return NetworkErrorScreen(
                          errorMessage: snapshot.error.toString(),
                          tapToRetryFunction: () {
                            Utils.showApiLoaderDialog(context);
                            _moreMyProfileBloc.fetchMyProfileData();
                          },
                        );
                      }*/
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*void _initSelectedAnswer(MobileEventDetails firstNameMobileEventDetails, MobileEventDetails ageMobileEventDetails, MobileEventDetails sexMobileEventDetails, MobileEventDetails genderMobileEventDetails) {
    if(_profileSelectedAnswerList == null && firstNameMobileEventDetails != null && ageMobileEventDetails != null && sexMobileEventDetails != null) {
      _profileSelectedAnswerList = [];

      _profileSelectedAnswerList.add(SelectedAnswers(questionTag: firstNameMobileEventDetails.questionTag, answer: firstNameMobileEventDetails.value));
      _profileSelectedAnswerList.add(SelectedAnswers(questionTag: ageMobileEventDetails.questionTag, answer: ageMobileEventDetails.value));
      _profileSelectedAnswerList.add(SelectedAnswers(questionTag: sexMobileEventDetails.questionTag, answer: sexMobileEventDetails.value));

      if(genderMobileEventDetails != null)
        _profileSelectedAnswerList.add(SelectedAnswers(questionTag: genderMobileEventDetails.questionTag, answer: genderMobileEventDetails.value));
    }
  }*/

  void _navigateToOtherScreen(String routeName, dynamic arguments) {
    widget.onPush(
        context, routeName, arguments);
  }

  @override
  void dispose() {
    _moreMyProfileBloc.dispose();
    super.dispose();
  }
}
