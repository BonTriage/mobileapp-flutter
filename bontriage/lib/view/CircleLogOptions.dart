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
  final String questionType;
  final String currentTag;
  final Function(String, String, String, bool, int) onDoubleTapItem;

  const CircleLogOptions(
      {Key key,
      this.logOptions,
      this.isForLogDay = false,
      this.preCondition = '',
      this.overlayNumber = 0,
      this.onCircleItemSelected,
      this.questionType = '',
      this.currentTag,
      this.onDoubleTapItem})
      : super(key: key);

  @override
  _CircleLogOptionsState createState() => _CircleLogOptionsState();
}

class _CircleLogOptionsState extends State<CircleLogOptions> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77,
      child: ListView.builder(
        itemCount: widget.logOptions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if(widget.questionType == 'multi') {
                      Values value = widget.logOptions[index];
                      if(value.isSelected) {
                        value.isSelected = false;
                        value.isDoubleTapped = false;
                      } else {
                        value.isSelected = true;
                      }
                    } else {
                      widget.logOptions.asMap().forEach((key, value) {
                        if(key == index) {
                          if(value.isSelected) {
                            value.isSelected = false;
                            value.isDoubleTapped = false;
                          } else {
                            value.isSelected = true;
                          }
                        } else {
                          value.isSelected = false;
                          value.isDoubleTapped = false;
                        }
                      });
                    }
                    if (widget.onCircleItemSelected != null) widget.onCircleItemSelected(index);
                    print('onTap');
                  });
                },
                onDoubleTap: () {
                  if(widget.onDoubleTapItem != null) {
                    setState(() {
                      if(widget.questionType == 'multi') {
                        if(widget.logOptions[index].isDoubleTapped) {
                          widget.logOptions[index].isDoubleTapped = false;
                        } else {
                          widget.logOptions[index].isSelected = true;
                          widget.logOptions[index].isDoubleTapped = true;
                        }
                      } else {
                        widget.logOptions.asMap().forEach((key, value) {
                          if(key == index) {
                            if(value.isDoubleTapped) {
                              value.isDoubleTapped = false;
                            } else {
                              value.isSelected = true;
                              value.isDoubleTapped = true;
                            }
                          } else {
                            value.isSelected = false;
                            value.isDoubleTapped = false;
                          }
                        });
                      }
                      widget.onDoubleTapItem(widget.currentTag, widget.logOptions[index].valueNumber, widget.questionType, widget.logOptions[index].isDoubleTapped, index);
                    });

                    if (widget.onCircleItemSelected != null) widget.onCircleItemSelected(index);
                    print('onDoubleTap');
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10),
                  width: 67,
                  height: 67,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.logOptions[index].isDoubleTapped ? Constant.doubleTapTextColor : Constant.chatBubbleGreen, width: 2),
                      color: (widget.logOptions[index].isSelected)
                          ? Constant.chatBubbleGreen
                          : Colors.transparent),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.logOptions[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: (widget.logOptions[index].isSelected)
                              ? Constant.bubbleChatTextView
                              : Constant.locationServiceGreen,
                          fontFamily: Constant.jostMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 67,
                height: 67,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: widget.logOptions[index].isSelected &&
                        (widget.preCondition
                            .contains(widget.logOptions[index].text)),
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircleAvatar(
                        backgroundColor:
                            Constant.addCustomNotificationTextColor,
                        child: Text(
                          widget.overlayNumber.toString(),
                          style: TextStyle(
                              color: Constant.locationServiceGreen,
                              fontSize: 10,
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
