import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';

class DiscoverScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;

  const DiscoverScreen({Key key, this.onPush}) : super(key: key);
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Discover Screen');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget.onPush(context, TabNavigatorRoutes.moreSupportRoute);
          },
          child: Text(
            'Demo Discover Screen',
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
