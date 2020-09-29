import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class CircleLogOptions extends StatefulWidget {
  final List<String> logOptions;

  const CircleLogOptions({Key key, this.logOptions}) : super(key: key);

  @override
  _CircleLogOptionsState createState() => _CircleLogOptionsState();
}

class _CircleLogOptionsState extends State<CircleLogOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        itemCount: widget.logOptions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Constant.chatBubbleGreen
              ),
            ),
            child: Center(
              child: Text(
                widget.logOptions[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Constant.locationServiceGreen,
                    fontFamily: Constant.jostRegular
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
