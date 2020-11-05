import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';

class OnBoardMultiSelectOptions extends StatefulWidget {
  final List<OnBoardSelectOptionModel> selectOptionList;
  final Function(String, String) selectedAnswerCallBack;
  final String questionTag;
  final List<SelectedAnswers> selectedAnswerListData;

  const OnBoardMultiSelectOptions(
      {Key key,
        this.selectOptionList,
        this.questionTag,
        this.selectedAnswerListData,
        this.selectedAnswerCallBack})
      : super(key: key);

  @override
  _OnBoardMultiSelectOptionsState createState() => _OnBoardMultiSelectOptionsState();
}

class _OnBoardMultiSelectOptionsState extends State<OnBoardMultiSelectOptions>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  String selectedValue;
  SelectedAnswers selectedAnswers;
  List<String> _valuesSelectedList = [];

  BoxDecoration _getBoxDecoration(int index) {
    if (!widget.selectOptionList[index].isSelected) {
      return BoxDecoration(
        border: Border.all(width: 1, color: Constant.selectTextColor),
        borderRadius: BorderRadius.circular(4),
      );
    } else {
      return BoxDecoration(
          border: Border.all(width: 1, color: Constant.chatBubbleGreen),
          borderRadius: BorderRadius.circular(4),
          color: Constant.chatBubbleGreen);
    }
  }

  Color _getOptionTextColor(int index) {
    if (widget.selectOptionList[index].isSelected) {
      return Constant.bubbleChatTextView;
    } else {
      return Constant.chatBubbleGreen;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.selectedAnswerListData != null) {
      selectedAnswers = widget.selectedAnswerListData.firstWhere(
              (model) => model.questionTag == widget.questionTag,
          orElse: () => null);
      if (selectedAnswers != null) {
        try {
          _valuesSelectedList =
              (jsonDecode(selectedAnswers.answer) as List<dynamic>).cast<
                  String>();
          _valuesSelectedList.forEach((element) {
            OnBoardSelectOptionModel value = widget.selectOptionList
                .firstWhere((valueElement) =>
            valueElement.optionText == element, orElse: () => null);

            if (value != null)
              value.isSelected = true;
          });
        } catch (e) {
          print(e.toString());
        }
      }
    }

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(OnBoardMultiSelectOptions oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (!_animationController.isAnimating) {
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

  void _onOptionSelected(int index) {
    widget.selectOptionList[index].isSelected = !widget.selectOptionList[index].isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Constant.chatBubbleHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Constant.selectAllThatApply,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: Constant.jostMedium,
                  color: Constant.selectTextColor),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectOptionList.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            /*selectedValue =
                                widget.selectOptionList[index].optionText;*/
                            _onOptionSelected(index);
                            if(widget.selectOptionList[index].isSelected) {
                              _valuesSelectedList.add(widget.selectOptionList[index].optionText);
                            } else {
                              _valuesSelectedList.remove(widget.selectOptionList[index].optionText);
                            }

                            widget.selectedAnswerCallBack(widget.questionTag, jsonEncode(_valuesSelectedList));
                          });
                        },
                        child: Container(
                          decoration: _getBoxDecoration(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              widget.selectOptionList[index].optionText,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: _getOptionTextColor(index),
                                  fontFamily: Constant.jostRegular,
                                  height: 1.2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
