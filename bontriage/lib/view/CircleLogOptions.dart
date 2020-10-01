import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/AddHeadacheLogModel.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class CircleLogOptions extends StatefulWidget {
  final List<Values> logOptions;

  const CircleLogOptions({Key key, this.logOptions}) : super(key: key);

  @override
  _CircleLogOptionsState createState() => _CircleLogOptionsState();
}

class _CircleLogOptionsState extends State<CircleLogOptions> {
  int lastIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
        itemCount: widget.logOptions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.logOptions[lastIndexSelected].isSelected = false;
                widget.logOptions[index].isSelected = !widget.logOptions[index].isSelected;
                lastIndexSelected = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(10),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Constant.chatBubbleGreen
                ),
                color: (widget.logOptions[index].isSelected) ? Constant.chatBubbleGreen : Colors.transparent
              ),
              child: Center(
                child: Text(
                  widget.logOptions[index].text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: (widget.logOptions[index].isSelected) ? Constant.bubbleChatTextView : Constant.locationServiceGreen,
                      fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
