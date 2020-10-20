import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class LogDayChipList extends StatefulWidget {
  final Questions question;
  final Function(String, String) onSelectCallback;

  const LogDayChipList({Key key, this.question, this.onSelectCallback}) : super(key: key);

  @override
  _LogDayChipListState createState() => _LogDayChipListState();
}

class _LogDayChipListState extends State<LogDayChipList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.question.values.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if(widget.question.questionType == 'multi') {
                if(widget.question.values[index].isSelected) {
                  widget.question.values[index].isSelected = false;
                  widget.question.values[index].isDoubleTapped = false;
                } else {
                  widget.question.values[index].isSelected = true;
                }
              } else {
                widget.question.values.asMap().forEach((key, value) {
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
            });

            if(widget.onSelectCallback != null) {
              widget.onSelectCallback(widget.question.tag, jsonEncode(widget.question));
            }
          },
          onDoubleTap: () {
            /*setState(() {
              if(widget.question.questionType == 'multi') {
                if(widget.question.values[index].isDoubleTapped) {
                  widget.question.values[index].isDoubleTapped = false;
                } else {
                  widget.question.values[index].isSelected = true;
                  widget.question.values[index].isDoubleTapped = true;
                }
              } else {
                widget.question.values.asMap().forEach((key, value) {
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
            });*/
          },
          child: Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: /*widget.question.values[index].isDoubleTapped ? Constant.doubleTapTextColor : Constant.chatBubbleGreen*/Constant.chatBubbleGreen,
                  width: widget.question.values[index].isDoubleTapped ? /*2*/1 : 1
              ),
              color: widget.question.values[index].isSelected
                  ? Constant.chatBubbleGreen
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                widget.question.values[index].text,
                style: TextStyle(
                    color: widget.question.values[index]
                        .isSelected
                        ? Constant.bubbleChatTextView
                        : Constant.locationServiceGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constant.jostRegular),
              ),
            ),
          ),
        );
      },
    );
  }
}
