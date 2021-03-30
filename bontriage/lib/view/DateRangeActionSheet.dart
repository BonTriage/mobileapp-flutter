import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DateRangeActionSheet extends StatefulWidget {
  @override
  _DateRangeActionSheetState createState() => _DateRangeActionSheetState();
}

class _DateRangeActionSheetState extends State<DateRangeActionSheet> {

  TextStyle _textStyle = TextStyle(
      fontFamily: Constant.jostRegular,
      color: Constant.cancelBlueColor,
      fontSize: 16
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(
                Constant.last2Weeks,
                overflow: TextOverflow.ellipsis,
                style: _textStyle,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.last2Weeks,);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              Constant.last4Weeks,
              overflow: TextOverflow.ellipsis,
              style: _textStyle,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.last4Weeks,);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              Constant.last2Months,
              overflow: TextOverflow.ellipsis,
              style: _textStyle,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.last2Months,);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              Constant.last3Months,
              overflow: TextOverflow.ellipsis,
              style: _textStyle,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.last3Months,);
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
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          },
        )
    );
  }
}
