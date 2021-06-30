import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:provider/provider.dart';

class MoreAgeScreen extends StatefulWidget {
  final List<SelectedAnswers> selectedAnswerList;
  final Future<dynamic> Function(String,dynamic) openActionSheetCallback;

  const MoreAgeScreen({Key key, @required this.selectedAnswerList, @required this.openActionSheetCallback}): super(key: key);
  @override
  _MoreAgeScreenState createState() =>
      _MoreAgeScreenState();
}

class _MoreAgeScreenState
    extends State<MoreAgeScreen> {

  double _currentAgeValue = 3;
  double _initialAgeValue;
  SelectedAnswers _selectedAnswers;

  @override
  void initState() {
    super.initState();
    if(widget.selectedAnswerList != null) {
      _selectedAnswers = widget.selectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileAgeTag, orElse: () => null);
      if(_selectedAnswers != null) {
        double ageValue = double.tryParse(_selectedAnswers.answer);

        if (ageValue != null) {
          _currentAgeValue = ageValue;
          _initialAgeValue = _currentAgeValue;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _openSaveAndExitActionSheet();
        return false;
      },
      child: Container(
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
                        _openSaveAndExitActionSheet();
                      },
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constant.moreBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Image(
                              width: 20,
                              height: 20,
                              image: AssetImage(Constant.leftArrow),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              Constant.age,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 16,
                                  fontFamily: Constant.jostMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Constant.backgroundColor,
                        inactiveTrackColor: Constant.backgroundColor,
                        thumbColor: Constant.chatBubbleGreen,
                        overlayColor: Constant.chatBubbleGreenTransparent,
                        trackHeight: 7,
                      ),
                      child: Slider(
                        value: _currentAgeValue,
                        min: 3,
                        max: 72,
                        onChanged: (double age) {
                          setState(() {
                            _currentAgeValue = age;
                          });
                        },
                      ),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '3',
                                    style: TextStyle(
                                      color: Constant.locationServiceGreen,
                                      fontFamily: Constant.jostMedium,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '72',
                                    style: TextStyle(
                                      color: Constant.locationServiceGreen,
                                      fontFamily: Constant.jostMedium,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Constant.chatBubbleGreenBlue
                                ),
                                child: Center(
                                  child: Text(
                                    _currentAgeValue.toInt().toString(),
                                    style: TextStyle(
                                      color: Constant.locationServiceGreen,
                                      fontFamily: Constant.jostMedium,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                Constant.yearsOld,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Constant.locationServiceGreen,
                                  fontFamily: Constant.jostMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Constant.slideToEnterYourAge,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 14,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSaveAndExitActionSheet() async {
    if (_initialAgeValue != null) {
      var moreAgeInfo = Provider.of<MoreAgeInfo>(context, listen: false);
      //double _currentAgeValue =
      if (_initialAgeValue != _currentAgeValue) {
        var result = await widget.openActionSheetCallback(Constant.saveAndExitActionSheet,null);
        if (result != null) {
          if (result == Constant.saveAndExit) {
            _selectedAnswers.answer = _currentAgeValue.toInt().toString();
          }
          Navigator.pop(context, result == Constant.saveAndExit);
        }
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }
}

class MoreAgeInfo with ChangeNotifier {
  double _currentAgeValue = 3;

  double getCurrentAgeValue() => _currentAgeValue;

  updateMoreAgeInfo(double currentAgeValue) {
    _currentAgeValue = currentAgeValue;
    notifyListeners();
  }
}
