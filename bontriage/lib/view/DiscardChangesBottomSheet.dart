import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DiscardChangesBottomSheet extends StatefulWidget {
  @override
  _DiscardChangesBottomSheetState createState() =>
      _DiscardChangesBottomSheetState();
}

class _DiscardChangesBottomSheetState
    extends State<DiscardChangesBottomSheet> {
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
                Constant.saveAndExit,
                overflow: TextOverflow.ellipsis,
                style: _textStyle,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.saveAndExit);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
                'Discard Changes',
                overflow: TextOverflow.ellipsis,
                style: _textStyle.copyWith(
                  color: Constant.deleteLogRedColor,
                )
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.discardChanges);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            Constant.cancel,
            overflow: TextOverflow.ellipsis,
            style: _textStyle,
          ),
          isDefaultAction: true,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          },
        ),
    );
  }
}
