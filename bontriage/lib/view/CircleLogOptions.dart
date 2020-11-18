import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class CircleLogOptions extends StatefulWidget {
  final List<Values> logOptions;
  final bool isForMedication;
  final String preCondition;
  final int overlayNumber;
  final Function(int) onCircleItemSelected;
  final String questionType;
  final String currentTag;
  final Function(String, String, String, bool, int) onDoubleTapItem;

  const CircleLogOptions(
      {Key key,
      this.logOptions,
      this.isForMedication = false,
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
      height: 78,
      child: ListView.builder(
        itemCount: widget.logOptions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: (index == 0) ? 15 : 0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(widget.logOptions[index].text != Constant.plusText) {
                        if (widget.questionType == 'multi') {
                          Values value = widget.logOptions[index];
                          if (value.isSelected) {
                            value.isSelected = false;
                            value.isDoubleTapped = false;
                          } else {
                            value.isSelected = true;
                          }
                        } else {
                          widget.logOptions.asMap().forEach((key, value) {
                            if (key == index) {
                              if (value.isSelected) {
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
                      }
                      if (widget.onCircleItemSelected != null)
                        widget.onCircleItemSelected(index);
                    });
                  },
                  onDoubleTap: () {
                    if (widget.onDoubleTapItem != null) {
                      if(widget.logOptions[index].text != Constant.plusText) {
                        setState(() {
                          if (widget.questionType == 'multi') {
                            if (widget.logOptions[index].isDoubleTapped) {
                              widget.logOptions[index].isDoubleTapped = false;
                            } else {
                              widget.logOptions[index].isSelected = true;
                              widget.logOptions[index].isDoubleTapped = true;
                            }
                          } else {
                            widget.logOptions.asMap().forEach((key, value) {
                              if (key == index) {
                                if (value.isDoubleTapped) {
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
                          widget.onDoubleTapItem(
                              widget.currentTag,
                              widget.logOptions[index].valueNumber,
                              widget.questionType,
                              widget.logOptions[index].isDoubleTapped,
                              index);
                        });

                        if (widget.onCircleItemSelected != null)
                          widget.onCircleItemSelected(index);
                        print('onDoubleTap');
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(10),
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: widget.logOptions[index].isDoubleTapped
                                ? Constant.addCustomNotificationTextColor
                                : Constant.chatBubbleGreen,
                            width: 1.5),
                        color: (widget.logOptions[index].isSelected)
                            ? (widget.logOptions[index].isDoubleTapped) ? Constant.addCustomNotificationTextColor : Constant.chatBubbleGreen
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
                      visible: ((widget.isForMedication && widget.logOptions[index].isSelected) || (widget.logOptions[index].isSelected &&
                          (widget.preCondition
                              .contains(widget.logOptions[index].text)))),
                      child: Container(
                        width: 20,
                        height: 20,
                        child: CircleAvatar(
                          backgroundColor:
                              Constant.backgroundTransparentColor,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              Constant.threeDots,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
