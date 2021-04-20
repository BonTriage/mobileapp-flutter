import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CustomScrollBar.dart';

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
          _valuesSelectedList.forEach((element) {
            Values value = widget.question.values.firstWhere((
                valueElement) => valueElement.text == element,
                orElse: () => null);

            if (value != null)
              value.isSelected = true;
            else
              widget.question.values.add(Values(text: element,
                  isSelected: true,
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

              if (value != null)
                value.isSelected = true;
              else
                widget.question.values.add(Values(text: element,
                    isSelected: true,
                    valueNumber: (widget.question.values.length + 1).toString()));
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
                child: CustomScrollBar(
                  isAlwaysShown: true,
                  controller: _scrollController,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if(widget.isFromMoreScreen) {
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

class BottomSheetContainer extends StatefulWidget {
  final Questions question;
  final Function(int) selectedAnswerCallback;
  final bool isFromMoreScreen;

  const BottomSheetContainer(
      {Key key, this.selectedAnswerCallback, this.question, this.isFromMoreScreen = false})
      : super(key: key);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  String searchText = '';
  bool _isExtraDataAdded = false;

  Color _getOptionTextColor(int index) {
    if (widget.question.values[index].isSelected) {
      return Constant.bubbleChatTextView;
    } else {
      return widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen;
    }
  }

  Color _getOptionBackgroundColor(int index) {
    if (widget.question.values[index].isSelected) {
      return widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen;
    } else {
      return Constant.transparentColor;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.6,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Constant.backgroundTransparentColor
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: Constant.jostRegular,
                          color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: TextField(
                    onChanged: (searchText) {
                      if (searchText
                          .trim()
                          .isNotEmpty) {
                        Values valueData = widget.question.values.firstWhere((
                            element) =>
                            element.text.toLowerCase().contains(
                                searchText.toLowerCase().trim()),
                            orElse: () => null);

                        if (valueData == null) {
                          if (!_isExtraDataAdded) {
                            widget.question.values.add(
                                Values(text: searchText, isNewlyAdded: true));
                            _isExtraDataAdded = true;
                          } else {
                            if(widget.question.values.last.isSelected) {
                              widget.question.values.add(
                                  Values(text: searchText, isNewlyAdded: true));
                            } else {
                              widget.question.values.last.text = searchText;
                            }
                          }
                        } else {
                          if(_isExtraDataAdded) {
                            if(!valueData.isNewlyAdded) {
                              widget.question.values.removeLast();
                              _isExtraDataAdded = false;
                            } else {
                              widget.question.values.last.text = searchText;
                            }
                          }
                        }
                      }
                      setState(() {
                        this.searchText = searchText;
                      });
                    },
                    style: TextStyle(
                        color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                        fontSize: 15,
                        fontFamily: Constant.jostMedium),
                    cursorColor: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                    decoration: InputDecoration(
                      hintText: Constant.searchType,
                      hintStyle: TextStyle(
                          color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                          fontSize: 13,
                          fontFamily: Constant.jostMedium),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen)),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    itemCount: widget.question.values.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(!widget.question.values[index].isSelected && widget.question.values[index].isNewlyAdded)
                                  _isExtraDataAdded = false;
                                widget.question.values[index].isSelected =
                                !widget.question.values[index].isSelected;
                                widget.selectedAnswerCallback(index);
                              });
                            },
                            child: Visibility(
                              visible: (searchText
                                  .trim()
                                  .isNotEmpty)
                                  ? widget.question.values[index]
                                  .text.toLowerCase()
                                  .contains(searchText.trim().toLowerCase())
                                  : true,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 2, top: 0, right: 2),
                                color: _getOptionBackgroundColor(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Text(
                                    widget.question.values[index].text,
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: _getOptionTextColor(index),
                                        fontFamily: Constant.jostMedium,
                                        height: 1.2),
                                  ),
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
          ),
        ],
      ),
    );
  }
}
