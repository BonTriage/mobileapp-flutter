import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CustomScrollBar.dart';

import 'BottomSheetContainer.dart';

class SignUpBottomSheet extends StatefulWidget {
  final Questions question;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Function(Questions, List<String>) selectAnswerCallback;
  final List<SelectedAnswers> selectAnswerListData;
  final bool isFromMoreScreen;
  final Function(Questions, Function(int)) openTriggerMedicationActionSheetCallback;

  SignUpBottomSheet(
      {Key key, this.question, this.selectAnswerCallback, this.selectAnswerListData, this.isFromMoreScreen = false, this.openTriggerMedicationActionSheetCallback})
      : super(key: key);

  @override
  _SignUpBottomSheetState createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  List<String> _valuesSelectedList = [];
  ScrollController _scrollController;

  bool _isShowScrollBar = false;
  GlobalKey _chipsKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();

    if (widget.selectAnswerListData != null) {
      SelectedAnswers selectedAnswers = widget.selectAnswerListData.firstWhere((
          element) => element.questionTag == widget.question.tag,
          orElse: () => null);

      if (selectedAnswers != null) {
        try {
          _valuesSelectedList =
              (jsonDecode(selectedAnswers.answer) as List<dynamic>).cast<
                  String>();
          _valuesSelectedList = _valuesSelectedList.toList();
          _valuesSelectedList.forEach((element) {
            Values value = widget.question.values.firstWhere((
                valueElement) => valueElement.text == element,
                orElse: () => null);

            if (value != null) {
                value.isSelected = true;
            }
            else
              widget.question.values.add(Values(text: element,
                  isSelected: true,
                  isNewlyAdded: true,
                  valueNumber: (widget.question.values.length + 1).toString()));
          });
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  void didUpdateWidget(SignUpBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }

    if(widget.isFromMoreScreen ?? false) {

      if (widget.selectAnswerListData != null) {
        SelectedAnswers selectedAnswers = widget.selectAnswerListData.firstWhere((
            element) => element.questionTag == widget.question.tag,
            orElse: () => null);

        if (selectedAnswers != null) {
          try {
            _valuesSelectedList =
                (jsonDecode(selectedAnswers.answer) as List<dynamic>).cast<
                    String>();
            _valuesSelectedList.forEach((element) {
              Values value = widget.question.values.firstWhere((
                  valueElement) => valueElement.text == element,
                  orElse: () => null);

              if (value != null) {
                  value.isSelected = true;
              }
              else {
                print('adding here 2');
                widget.question.values.add(Values(text: element,
                    isSelected: true,
                    isNewlyAdded: true,
                    valueNumber: (widget.question.values.length + 1).toString()));
              }
            });
          } catch (e) {
            print(e.toString());
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    widget.question.values.removeWhere((element) => element.isNewlyAdded ?? false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100),
            child: Container(
              key: _chipsKey,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 350),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 20,
                    children: <Widget>[
                      for (var i = 0; i < widget.question.values.length; i++)
                        if (widget.question.values[i].isSelected)
                          Chip(
                            label: Text(widget.question.values[i].text,
                              textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),),
                            backgroundColor: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                            deleteIcon: IconButton(
                              icon: new Image.asset('images/cross.png'),
                              onPressed: () {
                                setState(() {
                                  widget.question.values[i].isSelected = false;
                                });
                                _valuesSelectedList.remove(
                                    widget.question.values[i].text);
                                widget.selectAnswerCallback(
                                    widget.question, _valuesSelectedList);
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if(widget.isFromMoreScreen) {
                  _valuesSelectedList.forEach((element) {
                    Values value = widget.question.values.firstWhere((
                        valueElement) => valueElement.text == element,
                        orElse: () => null);

                    if (value != null) {
                      value.isSelected = true;
                    }
                  });
                  widget.openTriggerMedicationActionSheetCallback(
                    widget.question,
                          (index) {
                        Values value = widget.question.values[index];
                        if (value.isSelected) {
                          if(!value.isValid) {
                            _valuesSelectedList.clear();
                            widget.question.values.forEach((element) {
                              element.isSelected = false;
                            });
                            value.isSelected = true;
                          } else {
                            Values noneOfTheAboveValue = widget.question.values.firstWhere((element) => !element.isValid);
                            if(noneOfTheAboveValue != null) {
                              noneOfTheAboveValue.isSelected = false;
                              _valuesSelectedList.removeWhere((element) =>
                              element == noneOfTheAboveValue.text);
                            }
                          }
                          _valuesSelectedList.add(
                              value.text);
                        } else {
                          _valuesSelectedList.remove(
                              value.text);
                        }
                        widget.selectAnswerCallback(
                            widget.question, _valuesSelectedList);
                        setState(() {});

                        //Remove this code after testing
                        _valuesSelectedList.forEach((element) {
                          print(element + '\n');
                        });
                      }
                  );
                }
                else showBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context)=>
                    BottomSheetContainer(
                        question: widget.question,
                        isFromMoreScreen: widget.isFromMoreScreen,
                        selectedAnswerCallback: (index) {
                          print('hello');
                          Values value = widget.question.values[index];
                          if (value.isSelected) {
                            if(!value.isValid) {
                              _valuesSelectedList.clear();
                              widget.question.values.forEach((element) {
                                element.isSelected = false;
                              });
                              value.isSelected = true;
                            } else {
                              Values noneOfTheAboveValue = widget.question.values.firstWhere((element) => !element.isValid);
                              if(noneOfTheAboveValue != null) {
                                noneOfTheAboveValue.isSelected = false;
                                _valuesSelectedList.removeWhere((element) =>
                                element == noneOfTheAboveValue.text);
                              }
                            }
                            _valuesSelectedList.add(
                                value.text);
                          } else {
                            _valuesSelectedList.remove(
                                value.text);
                          }
                          widget.selectAnswerCallback(
                              widget.question, _valuesSelectedList);
                          setState(() {});

                          //Remove this code after testing
                          _valuesSelectedList.forEach((element) {
                            print(element + '\n');
                          });
                        })
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      Constant.searchYourType,
                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                      style: TextStyle(
                          color: Constant.selectTextColor,
                          fontSize: 14,
                          fontFamily: Constant.jostMedium),
                    ),
                  ),
                  Container(
                    child: Image(
                      image: AssetImage(widget.isFromMoreScreen ? Constant.downArrow2 : Constant.downArrow),
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
            thickness: 2,
            height: 10,
            indent: 30,
            endIndent: 30,
          ),
        ],
      ),
    );
  }

  bool _getIsAlwaysShownValue() {
    try {
      RenderBox chipRenderBox = _chipsKey.currentContext.findRenderObject();
      Size chipSize = chipRenderBox.size;

      print('ChipsHeight???${chipSize.height}');

      return chipSize.height >= 96;
    } catch(e) {
      return true;
    }
  }
}
