import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/models/QuestionsModel.dart';

class BottomSheetContainer extends StatefulWidget {
  final Questions question;
  final Function(int) selectedAnswerCallback;
  final bool isFromMoreScreen;

  const BottomSheetContainer(
      {Key key, this.selectedAnswerCallback, this.question, this.isFromMoreScreen = false})
      : super(key: key);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  String searchText = '';
  bool _isExtraDataAdded = false;

  bool _isDoneButtonClicked = false;

  Color _getOptionTextColor(int index) {
    if (widget.question.values[index].isSelected) {
      return Constant.bubbleChatTextView;
    } else {
      return widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen;
    }
  }

  Color _getOptionBackgroundColor(int index) {
    if (widget.question.values[index].isSelected) {
      return widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen;
    } else {
      return Constant.transparentColor;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.6,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Constant.backgroundTransparentColor
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: (){
                        _isDoneButtonClicked = true;
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: Constant.jostRegular,
                          color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: TextField(
                    onChanged: (searchText) {
                      if (searchText
                          .trim()
                          .isNotEmpty) {
                        Values valueData = widget.question.values.firstWhere((
                            element) =>
                            element.text.toLowerCase().contains(
                                searchText.toLowerCase().trim()),
                            orElse: () => null);

                        if (valueData == null) {
                          if (!_isExtraDataAdded) {
                            widget.question.values.add(
                                Values(text: searchText, isNewlyAdded: true));
                            _isExtraDataAdded = true;
                          } else {
                            if(widget.question.values.last.isSelected) {
                              widget.question.values.add(
                                  Values(text: searchText, isNewlyAdded: true));
                            } else {
                              widget.question.values.last.text = searchText;
                            }
                          }
                        } else {
                          if(_isExtraDataAdded) {
                            if(!valueData.isNewlyAdded) {
                              widget.question.values.removeLast();
                              _isExtraDataAdded = false;
                            } else {
                              widget.question.values.last.text = searchText;
                            }
                          }
                        }
                      }
                      setState(() {
                        this.searchText = searchText;
                      });
                    },
                    style: TextStyle(
                        color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                        fontSize: 15,
                        fontFamily: Constant.jostMedium),
                    cursorColor: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                    decoration: InputDecoration(
                      hintText: Constant.searchType,
                      hintStyle: TextStyle(
                          color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen,
                          fontSize: 13,
                          fontFamily: Constant.jostMedium),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.isFromMoreScreen ? Constant.locationServiceGreen : Constant.chatBubbleGreen)),
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
                                if(!widget.question.values[index].isSelected && widget.question.values[index].isNewlyAdded)
                                  _isExtraDataAdded = false;
                                widget.question.values[index].isSelected =
                                !widget.question.values[index].isSelected;
                                widget.selectedAnswerCallback(index);
                              });
                            },
                            child: Visibility(
                              visible: (searchText
                                  .trim()
                                  .isNotEmpty)
                                  ? widget.question.values[index]
                                  .text.toLowerCase()
                                  .contains(searchText.trim().toLowerCase())
                                  : true,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 2, top: 0, right: 2),
                                color: _getOptionBackgroundColor(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Text(
                                    widget.question.values[index].text,
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _removeLastCustomValue();
    super.dispose();
  }

  void _removeLastCustomValue() {
    if(_isExtraDataAdded && !_isDoneButtonClicked) {
      Values lastValue = widget.question.values.last;

      if(lastValue.isNewlyAdded && !lastValue.isSelected) {
        widget.question.values.removeLast();
      }
    }
  }
}