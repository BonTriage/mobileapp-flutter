import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';

class SignUpBottomSheet extends StatefulWidget {
  final Questions question;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Function(Questions, List<String>) selectAnswerCallback;
  final List<SelectedAnswers> selectAnswerListData;

  SignUpBottomSheet({Key key, this.question, this.selectAnswerCallback, this.selectAnswerListData}) : super(key: key);

  @override
  _SignUpBottomSheetState createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> with TickerProviderStateMixin {
  AnimationController _animationController;
  List<String> _valuesSelectedList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();

    if(widget.selectAnswerListData != null) {
      SelectedAnswers selectedAnswers = widget.selectAnswerListData.firstWhere((element) => element.questionTag == widget.question.tag, orElse: () => null);

      if(selectedAnswers != null) {
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
              widget.question.values.add(Values(text: element, isSelected: true, valueNumber: (widget.question.values.length + 1).toString()));
          });
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  void didUpdateWidget(SignUpBottomSheet oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(!_animationController.isAnimating) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
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
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 350),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 20,
                    children: <Widget>[
                      for (var i = 0; i < widget.question.values.length; i++)
                        if (widget.question.values[i].isSelected)
                          Chip(
                            label: Text(widget.question.values[i].text),
                            backgroundColor: Constant.chatBubbleGreen,
                            deleteIcon: IconButton(
                              icon: new Image.asset('images/cross.png'),
                              onPressed: () {
                                setState(() {
                                  widget.question.values[i].isSelected = false;
                                });
                                _valuesSelectedList.remove(widget.question.values[i].text);
                                widget.selectAnswerCallback(widget.question, _valuesSelectedList);
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
              onTap: () {
                showBottomSheet(
                    elevation: 4,
                    backgroundColor: Constant.backgroundTransparentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    context: context,
                    builder: (context) => BottomSheetContainer(
                        question: widget.question,
                        selectedAnswerCallback: (index) {
                          if(widget.question.values[index].isSelected) {
                            _valuesSelectedList.add(widget.question.values[index].text);
                          } else {
                            _valuesSelectedList.remove(widget.question.values[index].text);
                          }
                          widget.selectAnswerCallback(widget.question, _valuesSelectedList);
                          setState(() {});
                        }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      Constant.searchYourType,
                      style: TextStyle(
                          color: Constant.selectTextColor,
                          fontSize: 14,
                          fontFamily: Constant.jostMedium),
                    ),
                  ),
                  Container(
                    child: Image(
                      image: AssetImage(Constant.downArrow),
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Constant.chatBubbleGreen,
            thickness: 2,
            height: 10,
            indent: 30,
            endIndent: 30,
          ),
        ],
      ),
    );
  }
}

class BottomSheetContainer extends StatefulWidget {
  final Questions question;
  final Function(int) selectedAnswerCallback;

  const BottomSheetContainer(
      {Key key, this.selectedAnswerCallback, this.question})
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
      return Constant.chatBubbleGreen;
    }
  }

  Color _getOptionBackgroundColor(int index) {
    if (widget.question.values[index].isSelected) {
      return Constant.chatBubbleGreen;
    } else {
      return Constant.transparentColor;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              onChanged: (searchText) {
                if(searchText.trim().isNotEmpty) {
                  Values valueData = widget.question.values.firstWhere((element) => element.text.toLowerCase().contains(searchText.toLowerCase().trim()), orElse: () => null);

                  if(valueData == null) {
                    if(!_isExtraDataAdded) {
                      widget.question.values.add(Values(text: searchText));
                      _isExtraDataAdded = true;
                    } else {
                      widget.question.values.last.text = searchText;
                    }
                  }
                }
                setState(() {
                  this.searchText = searchText;
                });
              },
              style: TextStyle(
                  color: Constant.chatBubbleGreen,
                  fontSize: 15,
                  fontFamily: Constant.jostMedium),
              cursorColor: Constant.chatBubbleGreen,
              decoration: InputDecoration(
                hintText: Constant.searchType,
                hintStyle: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontSize: 13,
                    fontFamily: Constant.jostMedium),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constant.chatBubbleGreen)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constant.chatBubbleGreen)),
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
                          widget.question.values[index].isSelected =
                          !widget.question.values[index].isSelected;
                          widget.selectedAnswerCallback(index);
                        });
                      },
                      child: Visibility(
                        visible: (searchText.trim().isNotEmpty) ? widget.question.values[index].text.toLowerCase().contains(searchText.trim().toLowerCase()) : true,
                        child: Container(
                          margin: EdgeInsets.only(left: 2, top: 0, right: 2),
                          color: _getOptionBackgroundColor(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              widget.question.values[index].text,
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
    );
  }
}
