import 'package:flutter/material.dart';
import 'package:mobile/models/TrendsTutorialDotModel.dart';
import 'package:mobile/util/constant.dart';

import 'TutorialChatBubble.dart';

class TrendsScreenTutorialDialog extends StatefulWidget {
  @override
  _TrendsScreenTutorialDialogState createState() => _TrendsScreenTutorialDialogState();
}

class _TrendsScreenTutorialDialogState extends State<TrendsScreenTutorialDialog> {

  List<List<InlineSpan>> _textSpanList;
  List<String> _chatBubbleTextList;
  int _currentIndex;
  List<TrendsTutorialDotModel> _trendsTutorialDotModelList1;
  List<TrendsTutorialDotModel> _trendsTutorialDotModelList2;
  List<TrendsTutorialDotModel> _trendsTutorialDotModelList3;
  GlobalKey _dotBoxGlobalKey;
  GlobalKey _dotGlobalKey;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    _dotBoxGlobalKey = GlobalKey();
    _dotGlobalKey = GlobalKey();

    _chatBubbleTextList = [
      Constant.trendsTutorialText1,
      Constant.trendsTutorialText2,
      Constant.trendsTutorialText3,
      Constant.trendsTutorialText4,
      Constant.trendsTutorialText5,
    ];

    _textSpanList = [
      [
        TextSpan(
          text: Constant.trendsTutorialText1,
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
      [
        TextSpan(
          text: 'A filled circle (',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(Icons.circle, size: 8, color: Constant.locationServiceGreen,),
          ),
        ),
        TextSpan(
          text: ') indicates if a certain behavior, potential trigger, or medication was present on a given day.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
      [
        TextSpan(
          text: 'An outlined circle (',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(Icons.brightness_1_outlined, size: 8, color: Constant.locationServiceGreen,),
          ),
        ),
        TextSpan(
          text: ') means you did not experience that item on a given day.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
      [
        TextSpan(
          text: Constant.trendsTutorialText4,
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
      [
        TextSpan(
          text: Constant.trendsTutorialText5,
          style: TextStyle(
            fontSize: 16,
            fontFamily: Constant.jostRegular,
            height: 1.3,
            color: Constant.chatBubbleGreen,
          ),
        ),
      ],
    ];

    _initTrendsTutorialDotModel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        color: Constant.backgroundColor,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 140,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image(
                        image: AssetImage(
                            Constant.graph,
                        ),
                      ),
                    ),
                    Column(
                      key: _dotBoxGlobalKey,
                      children: [
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 10),
                          child: Row(
                            children: _getDots(1),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 10),
                          child: Row(
                            children: _getDots(2),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 10),
                          child: Row(
                            children: _getDots(3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: true,
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Image(
                        image: AssetImage(
                          Constant.trendsTutorialArrowUp,
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: /*Constant.backgroundColor.withOpacity(0.9)*/Colors.transparent,
              child: Column(
                children: [
                  TutorialChatBubble(
                    chatBubbleText: _chatBubbleTextList[_currentIndex],
                    textSpanList: _textSpanList[_currentIndex],
                    currentIndex: _currentIndex,
                    nextButtonFunction: () {
                      if(_currentIndex < _textSpanList.length - 1) {
                        setState(() {
                          _currentIndex++;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    backButtonFunction: () {
                      if(_currentIndex != 0) {
                        setState(() {
                          _currentIndex--;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDots(int type) {
    List<Widget> dotsList;

    switch(type) {
      case 1:
        dotsList = List.generate(31, (index) => Expanded(
          child: Center(
            child: Icon(
              _trendsTutorialDotModelList1[index].isSelected ? Icons.circle : Icons.brightness_1_outlined,
              size: 8,
              color: Constant.locationServiceGreen,
            ),
          ),
        ));
        break;
      case 2:
        dotsList = List.generate(31, (index) => Expanded(
          child: Center(
            child: Icon(
              _trendsTutorialDotModelList2[index].isSelected ? Icons.circle : Icons.brightness_1_outlined,
              size: 8,
              color: Constant.locationServiceGreen,
            ),
          ),
        ));
        break;
      default:
        dotsList = List.generate(31, (index) => Expanded(
          child: Center(
            child: Icon(
              _trendsTutorialDotModelList3[index].isSelected ? Icons.circle : Icons.brightness_1_outlined,
              size: 8,
              key: _trendsTutorialDotModelList3[index].isAddKey ? _dotGlobalKey : null,
              color: Constant.locationServiceGreen,
            ),
          ),
        ));
    }

    return dotsList;
  }

  void _initTrendsTutorialDotModel() {
    _trendsTutorialDotModelList1 = List.generate(31, (index) => TrendsTutorialDotModel());

    _trendsTutorialDotModelList1[5].isSelected = true;
    _trendsTutorialDotModelList1[9].isSelected = true;
    _trendsTutorialDotModelList1[10].isSelected = true;
    _trendsTutorialDotModelList1[11].isSelected = true;
    _trendsTutorialDotModelList1[12].isSelected = true;
    _trendsTutorialDotModelList1[13].isSelected = true;

    _trendsTutorialDotModelList2 = List.generate(31, (index) => TrendsTutorialDotModel());

    _trendsTutorialDotModelList2[5].isSelected = true;
    _trendsTutorialDotModelList2[8].isSelected = true;
    _trendsTutorialDotModelList2[9].isSelected = true;

    _trendsTutorialDotModelList3 = List.generate(31, (index) => TrendsTutorialDotModel());

    _trendsTutorialDotModelList3[5].isSelected = true;
    _trendsTutorialDotModelList3[9].isSelected = true;
    _trendsTutorialDotModelList3[13].isAddKey = true;
  }
}
