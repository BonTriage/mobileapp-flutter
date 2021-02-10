import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CompassScreen.dart';
import 'package:mobile/view/TrendsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CalendarScreen.dart';

class RecordScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;


  const RecordScreen({Key key, this.onPush, this.showApiLoaderCallback,this.navigateToOtherScreenCallback}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(RecordScreen oldWidget) {
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
                        fontSize: 15, fontFamily: Constant.jostMedium),
                    //For Selected tab
                    unselectedLabelStyle: TextStyle(
                        fontSize: 15, fontFamily: Constant.jostRegular),
                    //For Un-selected Tabs
                    labelColor: Color(0xff0E232F),
                    unselectedLabelColor: Color(0xffafd794),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffafd794)),
                    tabs: <Widget>[
                      Tab(text: 'Calendar'),
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
    print(tabPosition);
    /*  if(tabPosition == '1') {
        setState(() {
          currentIndex = 0;
           Utils.saveDataInSharedPreference(Constant.tabNavigatorState, "0");
        });
    }*/

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
        return CalendarScreen(
          showApiLoaderCallback: widget.showApiLoaderCallback,
          navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,
        );
      case 1:
        return CompassScreen(
          showApiLoaderCallback: widget.showApiLoaderCallback,
          navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,
        );
      default:
        return TrendsScreen(
          showApiLoaderCallback: widget.showApiLoaderCallback,
          navigateToOtherScreenCallback: widget.navigateToOtherScreenCallback,
        );
    }
  }

  void getRecordsTabPosition() {}
}
