import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class CircleLogOptions extends StatefulWidget {
  final List<Values> logOptions;
  final bool isForLogDay;
  final String preCondition;
  final int overlayNumber;
  final Function(int) onCircleItemSelected;

  const CircleLogOptions(
      {Key key,
      this.logOptions,
      this.isForLogDay = false,
      this.preCondition = '',
      this.overlayNumber = 0,
      this.onCircleItemSelected})
      : super(key: key);

  @override
  _CircleLogOptionsState createState() => _CircleLogOptionsState();
}

class _CircleLogOptionsState extends State<CircleLogOptions> {
  int lastIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: widget.logOptions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (!widget.logOptions[index].isSelected) {
                      widget.logOptions[lastIndexSelected].isSelected = false;
                      widget.logOptions[index].isSelected =
                          !widget.logOptions[index].isSelected;
                      lastIndexSelected = index;
                    } else {
                      widget.logOptions[index].isSelected = false;
                    }

                    if (widget.onCircleItemSelected != null) widget.onCircleItemSelected(index);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Constant.chatBubbleGreen),
                      color: (widget.logOptions[index].isSelected)
                          ? Constant.chatBubbleGreen
                          : Colors.transparent),
                  child: Center(
                    child: Text(
                      widget.logOptions[index].text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: (widget.logOptions[index].isSelected)
                            ? Constant.bubbleChatTextView
                            : Constant.locationServiceGreen,
                        fontFamily: Constant.jostRegular,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 90,
                height: 90,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: widget.logOptions[index].isSelected &&
                        (widget.preCondition
                            .contains(widget.logOptions[index].text)),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 3, right: 8),
                      width: 25,
                      height: 25,
                      child: CircleAvatar(
                        backgroundColor:
                            Constant.addCustomNotificationTextColor,
                        child: Text(
                          widget.overlayNumber.toString(),
                          style: TextStyle(
                              color: Constant.locationServiceGreen,
                              fontSize: 12,
                              fontFamily: Constant.jostRegular,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
