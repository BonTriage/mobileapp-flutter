import 'package:flutter/material.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/util/constant.dart';

class OnBoardSelectOptions extends StatefulWidget {
  final List<OnBoardSelectOptionModel> selectOptionList;
  final Function(String, String) selectedAnswerCallBack;
  final String questionTag;

  const OnBoardSelectOptions(
      {Key key,
      this.selectOptionList,
      this.questionTag,
      this.selectedAnswerCallBack})
      : super(key: key);

  @override
  _OnBoardSelectOptionsState createState() => _OnBoardSelectOptionsState();
}

class _OnBoardSelectOptionsState extends State<OnBoardSelectOptions>
    with SingleTickerProviderStateMixin {
  List<bool> _optionSelectedList = [];
  AnimationController _animationController;
  String selectedValue = "1";

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

    widget.selectOptionList.asMap().forEach((index, value) {
      if (index == 0) {
        _optionSelectedList.add(true);
      } else {
        _optionSelectedList.add(false);
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(OnBoardSelectOptions oldWidget) {
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
    widget.selectedAnswerCallBack(widget.questionTag, selectedValue);
    super.dispose();
  }

  void _onOptionSelected(int index) {
    widget.selectOptionList.asMap().forEach((key, value) {
      widget.selectOptionList[key].isSelected = index == key;
    });
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
              Constant.selectOne,
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
                            selectedValue =
                                widget.selectOptionList[index].optionId;
                            _onOptionSelected(index);
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
