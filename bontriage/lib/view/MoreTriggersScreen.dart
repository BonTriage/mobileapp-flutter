import 'package:flutter/material.dart';
import 'package:mobile/models/MoreTriggerArgumentModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/SignUpBottomSheet.dart';

class MoreTriggersScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final Function(List<Values>) openTriggerMedicationActionSheetCallback;
  final MoreTriggersArgumentModel moreTriggersArgumentModel;

  const MoreTriggersScreen({Key key, this.onPush, this.openActionSheetCallback, this.openTriggerMedicationActionSheetCallback, this.moreTriggersArgumentModel})
      : super(key: key);
  @override
  _MoreTriggersScreenState createState() => _MoreTriggersScreenState();
}

class _MoreTriggersScreenState extends State<MoreTriggersScreen> with SingleTickerProviderStateMixin {

  List<Values> _valuesList;

  @override
  void initState() {
    super.initState();

    _valuesList = [
      Values(isSelected: true, text: 'Triggers 1'),
      Values(isSelected: true, text: 'Triggers 2'),
      Values(isSelected: true, text: 'Triggers 3'),
      Values(isSelected: true, text: 'Triggers 4'),
      Values(isSelected: true, text: 'Triggers 5'),
      Values(isSelected: false, text: 'Triggers 6'),
    ];
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
                            "Triggers",
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
                  SignUpBottomSheet(
                    question: Questions(tag: 'headache.trigger', values: widget.moreTriggersArgumentModel.triggerValues),
                    isFromMoreScreen: true,
                    selectAnswerListData: widget.moreTriggersArgumentModel.selectedAnswerList,
                    selectAnswerCallback: (question, valuesList) {

                    },
                  ),
                  /*ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 350),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Wrap(
                            spacing: 10,
                            children: <Widget>[
                              for (var i = 0; i < _valuesList.length; i++)
                                if (_valuesList[i].isSelected)
                                  Chip(
                                    label: Text(_valuesList[i].text),
                                    labelStyle: TextStyle(
                                      fontFamily: Constant.jostRegular,
                                      fontSize: 14,
                                      color: Constant.bubbleChatTextView
                                    ),
                                    backgroundColor: Constant.locationServiceGreen,
                                    deleteIcon: IconButton(
                                      icon: new Image.asset('images/cross.png'),
                                      onPressed: () {
                                        setState(() {
                                          _valuesList[i].isSelected = false;
                                        });
                                      },
                                    ),
                                    onDeleted: () {},
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            Constant.searchYourType,
                            style: TextStyle(
                                color: Constant.locationServiceGreen.withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              widget.openTriggerMedicationActionSheetCallback(_valuesList);
                            },
                            child: Image(
                              image: AssetImage(Constant.downArrow2),
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: Constant.locationServiceGreen,
                      height: 7,
                      thickness: 2,
                    ),
                  ),*/
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      Constant.whichOfTheFollowingDoYouSuspect,
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
    );
  }
}

class BottomSheetContainer extends StatefulWidget {
  final List<Values> selectOptionList;
  final Function(int) selectedAnswerCallback;

  const BottomSheetContainer(
      {Key key, this.selectOptionList, this.selectedAnswerCallback})
      : super(key: key);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  Color _getOptionTextColor(int index) {
    if (widget.selectOptionList[index].isSelected) {
      return Constant.bubbleChatTextView;
    } else {
      return Constant.locationServiceGreen;
    }
  }

  Color _getOptionBackgroundColor(int index) {
    if (widget.selectOptionList[index].isSelected) {
      return Constant.locationServiceGreen;
    } else {
      return Constant.transparentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: TextField(
              style: TextStyle(
                  color: Constant.locationServiceGreen,
                  fontSize: 15,
                  fontFamily: Constant.jostMedium),
              cursorColor: Constant.chatBubbleGreen,
              decoration: InputDecoration(
                hintText: Constant.searchType,
                hintStyle: TextStyle(
                    color: Constant.locationServiceGreen.withOpacity(0.5),
                    fontSize: 13,
                    fontFamily: Constant.jostMedium),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constant.locationServiceGreen)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constant.locationServiceGreen)),
                contentPadding:
                EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              itemCount: widget.selectOptionList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectOptionList[index].isSelected =
                          !widget.selectOptionList[index].isSelected;
                          widget.selectedAnswerCallback(index);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 2, top: 0, right: 2),
                        color: _getOptionBackgroundColor(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            widget.selectOptionList[index].text,
                            style: TextStyle(
                                fontSize: 15,
                                color: _getOptionTextColor(index),
                                fontFamily: Constant.jostMedium,
                                height: 1.2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
