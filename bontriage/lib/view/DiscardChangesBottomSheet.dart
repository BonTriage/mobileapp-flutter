import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DiscardChangesBottomSheet extends StatefulWidget {
  @override
  _DiscardChangesBottomSheetState createState() =>
      _DiscardChangesBottomSheetState();
}

class _DiscardChangesBottomSheetState
    extends State<DiscardChangesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, Constant.discardChanges);
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              child: Center(
                child: Text(
                  'Discard Changes',
                  style: TextStyle(
                    color: Constant.deleteLogRedColor,
                    fontSize: 20,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                child: Text(
                  Constant.cancel,
                  style: TextStyle(
                    color: Constant.cancelBlueColor,
                    fontSize: 20,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
