import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreMyProfileBloc.dart';
import 'package:mobile/models/MoreMedicationArgumentModel.dart';
import 'package:mobile/models/MoreTriggerArgumentModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreMyProfileScreen extends StatefulWidget {
  final Future<dynamic> Function(BuildContext, String, dynamic) onPush;
  final Function(String) openActionSheetCallback;
  final Function(Stream, Function) showApiLoaderCallback;

  const MoreMyProfileScreen({Key key, this.onPush, this.openActionSheetCallback, this.showApiLoaderCallback})
      : super(key: key);

  @override
  _MoreMyProfileScreenState createState() => _MoreMyProfileScreenState();
}

class _MoreMyProfileScreenState extends State<MoreMyProfileScreen> {
  MoreMyProfileBloc _moreMyProfileBloc;


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
                  StreamBuilder<dynamic>(
                    stream: _moreMyProfileBloc.myProfileStream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData && snapshot.data is ResponseModel && snapshot.data != null) {
                        SelectedAnswers firstNameSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileFirstNameTag, orElse: () => null);
                        SelectedAnswers ageSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileAgeTag, orElse: () => null);
                        SelectedAnswers sexSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileSexTag, orElse: () => null);
                        SelectedAnswers genderSelectedAnswer = _moreMyProfileBloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileGenderTag, orElse: () => null);
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
                                  MoreSection(
                                    currentTag: Constant.profileEmailTag,
                                    text: Constant.email,
                                    moreStatus: _moreMyProfileBloc.userProfileInfoModel.email ?? '',
                                    isShowDivider: false,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                    selectedAnswerList: _moreMyProfileBloc.profileSelectedAnswerList,
                                  ),
                                ],
                              ),
                            ),
                            _getHeadacheTypeWidget(snapshot.data.headacheList),
                            SizedBox(height: 30,),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.moreBackgroundColor,
                              ),
                              child: _getTriggerMedicationWidget(snapshot.data),
                            ),
                            SizedBox(height: 20,),
                          ],
                        );
                      }
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

  void _navigateToOtherScreen(String routeName, dynamic arguments) async {
    var result = await widget.onPush(context, routeName, arguments);
    if(result != null) {
      if(result is bool && result) {
        _moreMyProfileBloc.initNetworkStreamController();
        widget.showApiLoaderCallback(_moreMyProfileBloc.networkStream, () {
          _moreMyProfileBloc.enterSomeDummyData();
          _moreMyProfileBloc.editMyProfileServiceCall();
        });
        _moreMyProfileBloc.editMyProfileServiceCall();
      } else if (result is String && result == 'Event Deleted') {
        _moreMyProfileBloc.initNetworkStreamController();
        widget.showApiLoaderCallback(_moreMyProfileBloc.networkStream, () {
          _moreMyProfileBloc.enterSomeDummyData();
          _moreMyProfileBloc.fetchMyProfileData();
        });
        _moreMyProfileBloc.fetchMyProfileData();
      } else if(routeName == TabNavigatorRoutes.moreTriggersScreenRoute ||
          routeName == TabNavigatorRoutes.moreMedicationsScreenRoute) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _moreMyProfileBloc.dispose();
    super.dispose();
  }

  Widget _getHeadacheTypeWidget(List<HeadacheTypeData> headacheList) {
    List<Widget> headacheTypeWidgetList = [];

    headacheList.asMap().forEach((index, value) {
      headacheTypeWidgetList.add(
        MoreSection(
          currentTag: Constant.headacheType,
          text: value.text,
          moreStatus: '',
          isShowDivider: index != headacheList.length - 1,
          navigateToOtherScreenCallback: _navigateToOtherScreen,
          headacheTypeData: value,
        ),
      );
    });

    return headacheList.length == 0 ? Container() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            children: headacheTypeWidgetList,
          ),
        ),
      ],
    );
  }

  Widget _getTriggerMedicationWidget(ResponseModel responseModel) {
    List<Values> triggerValues = responseModel.triggerValues;
    triggerValues.forEach((element) {
      element.isSelected = false;
    });
    List<Values> medicationValues = responseModel.medicationValues;
    medicationValues.forEach((element) {
      element.isSelected = false;
    });
    List<SelectedAnswers> selectedAnswerList = [];
    if(responseModel.triggerMedicationValues.length > 0)
      _moreMyProfileBloc.setSelectedAnswerList(selectedAnswerList, responseModel.triggerMedicationValues[0]);
    else
      _moreMyProfileBloc.setSelectedAnswerList(selectedAnswerList, null);
    return Column(
      children: [
        MoreSection(
          currentTag: Constant.myTriggers,
          text: Constant.myTriggers,
          moreStatus: '',
          isShowDivider: true,
          navigateToOtherScreenCallback: _navigateToOtherScreen,
          moreTriggersArgumentModel: MoreTriggersArgumentModel(
            eventId: responseModel.triggerMedicationValues.length > 0 ? responseModel.triggerMedicationValues[0].id.toString() : null,
            triggerValues: triggerValues,
            responseModel: responseModel,
            selectedAnswerList: selectedAnswerList
          ),
        ),
        MoreSection(
          currentTag: Constant.myMedications,
          text: Constant.myMedications,
          moreStatus: '',
          isShowDivider: false,
          navigateToOtherScreenCallback: _navigateToOtherScreen,
          moreMedicationArgumentModel: MoreMedicationArgumentModel(
            eventId: responseModel.triggerMedicationValues.length > 0 ? responseModel.triggerMedicationValues[0].id.toString() : null,
            medicationValues: medicationValues,
            responseModel: responseModel,
            selectedAnswerList: selectedAnswerList,
          ),
        ),
      ],
    );
  }
}
