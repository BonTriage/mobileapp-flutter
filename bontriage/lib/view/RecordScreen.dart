import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CalendarScreen.dart';
import 'CalendarTriggersScreen.dart';

class RecordScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const RecordScreen({Key key, this.onPush}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('Record Screen');
  }

  @override
  void didUpdateWidget(RecordScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getTabPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              child: DefaultTabController(
                length: 3,
                child: Container(
                  margin: EdgeInsets.only(
                      left: 30, right: 30, top: 30, bottom: 20),
                  padding: EdgeInsets.all(5),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Color(0xff0E232F),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20)),
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    labelStyle: TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.bold),
                    //For Selected tab
                    unselectedLabelStyle: TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal),
                    //For Un-selected Tabs
                    labelColor: Color(0xff0E232F),
                    unselectedLabelColor: Color(0xffafd794),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffafd794)),
                    tabs: <Widget>[
                      Tab(text: 'Calender'),
                      Tab(
                        text: 'Compass',
                      ),
                      Tab(
                        text: 'Trends',
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(children: [
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                _buildOffstageNavigator(2)
              ],),
            ),
          ],
        ),
      ),
    );
  }

  void getTabPosition() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String tabPosition =
        sharedPreferences.getString(Constant.tabNavigatorState);
    print("TabPosition:$tabPosition");
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: currentIndex != index,
      child: setWidget(index),
    );
  }

  setWidget(int index) {
    switch (index) {
      case 0:
        return CalendarScreen();
      case 0:
        return Container();
      default:
        return Container();
    }
  }
}