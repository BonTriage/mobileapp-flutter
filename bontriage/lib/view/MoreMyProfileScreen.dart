import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreMyProfileBloc.dart';
import 'package:mobile/models/ResponseModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
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

    print('InitState');

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
                                    isShowDivider: false,
                                    navigateToOtherScreenCallback: _navigateToOtherScreen,
                                    selectedAnswerList: _moreMyProfileBloc.profileSelectedAnswerList,
                                  ),
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
      }
    }
    //setState(() {});
  }

  @override
  void dispose() {
    _moreMyProfileBloc.dispose();
    super.dispose();
  }
}
