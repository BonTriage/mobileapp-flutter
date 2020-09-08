import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class OnBoardSelectOptions extends StatefulWidget {
  List<String> selectOptionList;

  OnBoardSelectOptions({Key key, this.selectOptionList}) : super(key: key);
  @override
  _OnBoardSelectOptionsState createState() => _OnBoardSelectOptionsState();
}

class _OnBoardSelectOptionsState extends State<OnBoardSelectOptions> {

  List<Widget> widgetsList;

  List<bool> _optionSelectedList = [];

  BoxDecoration _getBoxDecoration(int index) {
    if(!_optionSelectedList[index]) {
      return BoxDecoration(
        border: Border.all(
            width: 1,
            color: Constant.selectTextColor
        ),
        borderRadius: BorderRadius.circular(4),
      );
    } else {
      return BoxDecoration(
          border: Border.all(
              width: 1,
              color: Constant.chatBubbleGreen
          ),
          borderRadius: BorderRadius.circular(4),
          color: Constant.chatBubbleGreen
      );
    }
  }

  Color _getOptionTextColor(int index) {
    if(_optionSelectedList[index]) {
      return Constant.bubbleChatTextView;
    } else {
      return Constant.chatBubbleGreen;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widgetsList = [
      Text(
        Constant.selectOne,
        style: TextStyle(
            fontSize: 13,
            fontFamily: Constant.futuraMaxiLight,
            color: Constant.selectTextColor
        ),
      ),
      SizedBox(height: 10,),
    ];

    widget.selectOptionList.asMap().forEach((index, value) {
      if(index == 0) {
        _optionSelectedList.add(true);
      } else {
        _optionSelectedList.add(false);
      }
    });
  }

  void _onOptionSelected(int index) {
    _optionSelectedList.asMap().forEach((key, value) {
      _optionSelectedList[key] = index == key;
    });
  }


  @override
  Widget build(BuildContext context) {
    widgetsList.clear();
    widgetsList = [
      Text(
        Constant.selectOne,
        style: TextStyle(
            fontSize: 13,
            fontFamily: Constant.futuraMaxiLight,
            color: Constant.selectTextColor
        ),
      ),
      SizedBox(height: 10,),
    ];

    widget.selectOptionList.asMap().forEach((index, element) {
      widgetsList.add(GestureDetector(
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
              element,
              style: TextStyle(
                  fontSize: 14,
                  color: _getOptionTextColor(index),
                  fontFamily: Constant.futuraMaxiLight,
                height: 1.2
              ),
            ),
          ),
        ),
      ));

      widgetsList.add(SizedBox(height: 10,));
    });


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgetsList,
      ),
    );
  }
}
