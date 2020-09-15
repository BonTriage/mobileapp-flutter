import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpHeadacheAnswerListModel.dart';
import 'package:mobile/util/constant.dart';

class SignUpBottomSheet extends StatefulWidget {
  final List<SignUpHeadacheAnswerListModel> selectOptionList;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SignUpBottomSheet({Key key, this.selectOptionList}) : super(key: key);

  @override
  _SignUpBottomSheetState createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            height: 100,
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView(
                children: <Widget>[
                  Wrap(
                    spacing: 20,
                    children: <Widget>[
                      for (var i = 0; i < widget.selectOptionList.length; i++)
                        if (widget.selectOptionList[i].isSelected)
                          Chip(
                            label: Text(widget.selectOptionList[i].answerData),
                            backgroundColor: Constant.chatBubbleGreen,
                            deleteIcon: IconButton(
                              icon: new Image.asset('images/cross.png'),
                              onPressed: () {
                                setState(() {
                                  widget.selectOptionList[i].isSelected = false;
                                });
                              },
                            ),
                            onDeleted: () {},
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 50),
                child: Text(
                  Constant.searchYourType,
                  style: TextStyle(
                      color: Constant.selectTextColor,
                      fontSize: 14,
                      fontFamily: Constant.jostMedium),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: GestureDetector(
                  onTap: () {
                    showBottomSheet(
                        elevation: 4,
                        backgroundColor: Constant.backgroundTransparentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        context: context,
                        builder: (context) => BottomSheetContainer(
                            selectOptionList: widget.selectOptionList,
                            selectedAnswerCallback: (index) {
                              setState(() {});
                            }));
                    // BottomSheetContainer();
                  },
                  child: Image(
                    image: AssetImage(Constant.downArrow),
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Constant.chatBubbleGreen,
            height: 7,
            thickness: 2,
            indent: 40,
            endIndent: 40,
          ),
        ],
      ),
    );
  }
}

class BottomSheetContainer extends StatefulWidget {
  final List<SignUpHeadacheAnswerListModel> selectOptionList;
  final Function(int) selectedAnswerCallback;

  const BottomSheetContainer(
      {Key key, this.selectOptionList, this.selectedAnswerCallback})
      : super(key: key);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  Color _getOptionTextColor(int index) {
    if (widget.selectOptionList[index].isSelected) {
      return Constant.bubbleChatTextView;
    } else {
      return Constant.chatBubbleGreen;
    }
  }

  Color _getOptionBackgroundColor(int index) {
    if (widget.selectOptionList[index].isSelected) {
      return Constant.chatBubbleGreen;
    } else {
      return Constant.transparentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: TextField(
              style: TextStyle(
                  color: Constant.chatBubbleGreen,
                  fontSize: 15,
                  fontFamily: Constant.jostMedium),
              cursorColor: Constant.chatBubbleGreen,
              decoration: InputDecoration(
                hintText: Constant.searchType,
                hintStyle: TextStyle(
                    color: Constant.chatBubbleGreen,
                    fontSize: 15,
                    fontFamily: Constant.jostMedium),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constant.chatBubbleGreen)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constant.chatBubbleGreen)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              itemCount: widget.selectOptionList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectOptionList[index].isSelected =
                              !widget.selectOptionList[index].isSelected;
                          widget.selectedAnswerCallback(index);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 2, top: 10, right: 2),
                        color: _getOptionBackgroundColor(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            widget.selectOptionList[index].answerData,
                            style: TextStyle(
                                fontSize: 15,
                                color: _getOptionTextColor(index),
                                fontFamily: Constant.jostMedium,
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
          ),
        ],
      ),
    );
  }
}
