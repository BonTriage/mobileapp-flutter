import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DeleteLogOptionsBottomSheet extends StatefulWidget {
  @override
  _DeleteLogOptionsBottomSheetState createState() => _DeleteLogOptionsBottomSheetState();
}

class _DeleteLogOptionsBottomSheetState extends State<DeleteLogOptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, Constant.deleteLog);
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constant.whiteColorAlpha85
              ),
              child: Center(
                child: Text(
                  'Delete Log',
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
          SizedBox(height: 8,),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
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
        ],
      ),
    );
  }
}
