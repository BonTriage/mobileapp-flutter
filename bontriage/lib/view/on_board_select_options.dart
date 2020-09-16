import 'package:flutter/material.dart';
import 'package:mobile/models/OnBoardSelectOptionModel.dart';
import 'package:mobile/util/constant.dart';

class OnBoardSelectOptions extends StatefulWidget {
  final List<OnBoardSelectOptionModel> selectOptionList;

  const OnBoardSelectOptions({Key key, this.selectOptionList}) : super(key: key);

  @override
  _OnBoardSelectOptionsState createState() => _OnBoardSelectOptionsState();
}

class _OnBoardSelectOptionsState extends State<OnBoardSelectOptions> {
  List<bool> _optionSelectedList = [];

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
  }

  void _onOptionSelected(int index) {
    widget.selectOptionList.asMap().forEach((key, value) {
      widget.selectOptionList[key].isSelected = index == key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constant.chatBubbleHorizontalPadding),
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
                          _onOptionSelected(index);
                        });
                      },
                      child: Container(
                        decoration: _getBoxDecoration(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            widget.selectOptionList[index].optionText,
                            style: TextStyle(
                                fontSize: 14,
                                color: _getOptionTextColor(index),
                                fontFamily: Constant.jostRegular,
                                height: 1.2
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
