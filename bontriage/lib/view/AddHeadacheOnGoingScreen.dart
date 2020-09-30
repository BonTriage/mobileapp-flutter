import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/blocs/AddHeadacheLogBloc.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/AddHeadacheSection.dart';

class AddHeadacheOnGoingScreen extends StatefulWidget {
  @override
  _AddHeadacheOnGoingScreenState createState() => _AddHeadacheOnGoingScreenState();
}

class _AddHeadacheOnGoingScreenState extends State<AddHeadacheOnGoingScreen> with SingleTickerProviderStateMixin {
  DateTime _dateTime;
  AddHeadacheLogBloc _addHeadacheLogBloc;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();

    _addHeadacheLogBloc = AddHeadacheLogBloc();
    _addHeadacheLogBloc.fetchAddHeadacheLogData();
  }

  @override
  void dispose() {
    _addHeadacheLogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Constant.backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Utils.getMonthName(_dateTime.month)} ${_dateTime.day}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Constant.chatBubbleGreen,
                              fontFamily: Constant.jostMedium
                          ),
                        ),
                        Image(
                          image: AssetImage(Constant.closeIcon),
                          width: 26,
                          height: 26,
                        ),
                      ],
                    ),
                    Divider(
                      height: 30,
                      thickness: 1,
                      color: Constant.chatBubbleGreen,
                    ),
                    /*AddHeadacheSection(
                      headerText: Constant.headacheType,
                      subText: Constant.whatKindOfHeadache,
                      contentType: 'ht',
                    ),
                    AddHeadacheSection(
                      headerText: Constant.time,
                      subText: Constant.whenHeadacheStart,
                      contentType: 'time',
                    ),
                    AddHeadacheSection(
                      headerText: Constant.intensity,
                      subText: Constant.onAScaleOf1To10,
                      contentType: 'in',
                    ),
                    AddHeadacheSection(
                      headerText: Constant.intensity,
                      subText: Constant.onAScaleOf1To10,
                      contentType: 'dis',
                    ),*/
                    Container(
                      child: StreamBuilder<dynamic>(
                        stream: _addHeadacheLogBloc.addHeadacheLogDataStream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return Column(
                              children: _getAddHeadacheSection(snapshot.data),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Constant.addANote,
                        style: TextStyle(
                            fontSize: 16,
                            color: Constant.addCustomNotificationTextColor,
                            fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {},
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: Constant.chatBubbleGreen,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                Constant.save,
                                style: TextStyle(
                                    color: Constant.bubbleChatTextView,
                                    fontSize: 15,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {},
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.3, color: Constant.chatBubbleGreen),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                Constant.cancel,
                                style: TextStyle(
                                    color: Constant.chatBubbleGreen,
                                    fontSize: 15,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getAddHeadacheSection(List<dynamic> addHeadacheListData) {
    List<Widget> listOfWidgets = [];

    addHeadacheListData.forEach((element) {
      listOfWidgets.add(
          AddHeadacheSection(
            headerText: element.text,
            subText: element.helpText,
            contentType: element.tag,
            min: element.min.toDouble(),
            max: element.max.toDouble(),
          )
      );
    });

    return listOfWidgets;
  }
}
