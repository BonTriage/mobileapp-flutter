import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';

class DemoMeScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const DemoMeScreen({Key key, this.onPush}) : super(key: key);
  @override
  _DemoMeScreenState createState() => _DemoMeScreenState();
}

class _DemoMeScreenState extends State<DemoMeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Me Screen');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget.onPush(context, TabNavigatorRoutes.moreSettingRoute);
          },
          child: Text(
            'Demo Me Screen',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
