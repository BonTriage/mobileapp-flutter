import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class GenerateReportActionSheet extends StatefulWidget {
  @override
  _GenerateReportActionSheetState createState() => _GenerateReportActionSheetState();
}

class _GenerateReportActionSheetState extends State<GenerateReportActionSheet> {

  TextStyle _textStyle = TextStyle(
      fontFamily: Constant.jostRegular,
      color: Constant.cancelBlueColor,
      fontSize: 16
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
          title: Text(
            Constant.lindaJonesPdf,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 18,
                fontFamily: Constant.jostRegular
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                Constant.email,
                overflow: TextOverflow.ellipsis,
                style: _textStyle,
              ),
              onPressed: () {
                Navigator.pop(context, Constant.email);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                Constant.text,
                overflow: TextOverflow.ellipsis,
                style: _textStyle,
              ),
              onPressed: () {
                Navigator.pop(context, Constant.text);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                Constant.openYourProviderApp,
                overflow: TextOverflow.ellipsis,
                style: _textStyle,
              ),
              onPressed: () {
                Navigator.pop(context, Constant.openYourProviderApp);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                Constant.print,
                overflow: TextOverflow.ellipsis,
                style: _textStyle,
              ),
              onPressed: () {
                Navigator.pop(context, Constant.print);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
                Constant.cancel,
                overflow: TextOverflow.ellipsis,
                style: _textStyle
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, Constant.cancel);
            },
          )
      );
  }
}
