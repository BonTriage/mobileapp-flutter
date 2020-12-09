import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/UserHeadacheLogDayDetailsModel.dart';
import 'package:mobile/util/constant.dart';

class RecordCalendarHeadacheSection extends StatefulWidget {
  final UserHeadacheLogDayDetailsModel userHeadacheLogDayDetailsModel;

  RecordCalendarHeadacheSection({Key key, this.userHeadacheLogDayDetailsModel})
      : super(key: key);

  @override
  _RecordCalendarHeadacheSectionState createState() =>
      _RecordCalendarHeadacheSectionState();
}

class _RecordCalendarHeadacheSectionState
    extends State<RecordCalendarHeadacheSection> {
  int _value = 1;
  List<HeadacheData> userHeadacheListData;

  @override
  void initState() {
    super.initState();
    if (widget.userHeadacheLogDayDetailsModel.headacheLogDayListData == null) {
      userHeadacheListData = [];
    } else
      userHeadacheListData = widget.userHeadacheLogDayDetailsModel
          .headacheLogDayListData[0].headacheListData;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: userHeadacheListData.length > 0 || (widget.userHeadacheLogDayDetailsModel
          .headacheLogDayListData != null && widget.userHeadacheLogDayDetailsModel
          .headacheLogDayListData.length > 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                height: 20,
                width: 20,
                image: AssetImage(Constant.migraineIcon),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userHeadacheListData.length > 0 ? 'Headaches' : 'No Headaches Logged',
                      style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < userHeadacheListData.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 17,
                                  child: Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor:
                                            Constant.chatBubbleGreen),
                                    child: Radio(
                                      value: 1,
                                      activeColor: Constant.chatBubbleGreen,
                                      hoverColor: Constant.chatBubbleGreen,
                                      focusColor: Constant.chatBubbleGreen,
                                      groupValue: _value,
                                      onChanged: i == 5
                                          ? null
                                          : (int value) {
                                              setState(() {
                                                _value = value;
                                              });
                                            },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userHeadacheListData[i].headacheName,
                                          style: TextStyle(
                                              color: Constant.chatBubbleGreen,
                                              fontSize: 14,
                                              fontFamily: Constant.jostRegular),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          userHeadacheListData[i].headacheInfo,
                                          style: TextStyle(
                                              color: Constant.chatBubbleGreen60Alpha,
                                              fontFamily: Constant.jostRegular,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Visibility(
                                              visible: userHeadacheListData[i].headacheNote.isNotEmpty,
                                              child: Text(
                                                'Note:',
                                                style: TextStyle(
                                                    color: Constant
                                                        .chatBubbleGreen60Alpha,
                                                    fontFamily: Constant.jostRegular,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Visibility(
                                              visible:  userHeadacheListData[i].headacheNote.isNotEmpty,
                                              child: Text(
                                                userHeadacheListData[i].headacheNote,
                                                style: TextStyle(
                                                    color: Constant
                                                        .addCustomNotificationTextColor,
                                                    fontFamily: Constant.jostRegular,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(
            thickness: 0.5,
            color: Constant.chatBubbleGreen,
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),

    );
  }
}