import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';

class RecordScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const RecordScreen({Key key, this.onPush}) : super(key: key);
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Record Screen');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget.onPush(context, TabNavigatorRoutes.moreGenerateReportRoute);
          },
          child: Text(
            'Demo Record Screen',
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
