import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CompassScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CalendarScreen.dart';

class RecordScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String,dynamic) navigateToOtherScreenCallback;
  final Future<dynamic> Function(String,dynamic) openActionSheetCallback;


  const RecordScreen({Key key, this.onPush, this.showApiLoaderCallback,this.navigateToOtherScreenCallback, this.openActionSheetCallback}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    _saveRecordTabNavigatorState();
  }

  @override
  void didUpdateWidget(RecordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    //getTabPosition();
    _checkIfAnyButtonClicked();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        print('set state 3');
                        currentIndex = index;
                        _saveRecordTabNavigatorState();
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
    /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int tabPosition =
        sharedPreferences.getInt(Constant.tabNavigatorState);
    print("TabPosition:$tabPosition");
    print(tabPosition);*/
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
          openActionSheetCallback: widget.openActionSheetCallback,
        );
      default:
        return Container();
    }
  }

  void getRecordsTabPosition() {}

  Future<void> _saveRecordTabNavigatorState() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(Constant.recordTabNavigatorState, currentIndex);
  }

  Future<void> _checkIfAnyButtonClicked() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String isSeeMoreClicked = sharedPreferences.getString(Constant.isSeeMoreClicked) ?? Constant.blankString;
    String isViewTrendsClicked = sharedPreferences.getString(Constant.isViewTrendsClicked) ?? Constant.blankString;

    if(isSeeMoreClicked == Constant.trueString) {
      _tabController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
      setState(() {
        print('set state 1');
        currentIndex = 0;
        _saveRecordTabNavigatorState();
      });
    } else if (isViewTrendsClicked == Constant.trueString) {
      Future.delayed(Duration(seconds: 5), () {
        sharedPreferences.remove(Constant.isViewTrendsClicked);
      });
      setState(() {
        print('set state 2');
        currentIndex = 2;
        _saveRecordTabNavigatorState();
      });
      _tabController.animateTo(2, duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }
}
