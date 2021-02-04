import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class DeleteHeadacheTypeActionSheet extends StatefulWidget {
  @override
  _DeleteHeadacheTypeActionSheetState createState() =>
      _DeleteHeadacheTypeActionSheetState();
}

class _DeleteHeadacheTypeActionSheetState
    extends State<DeleteHeadacheTypeActionSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constant.whiteColorAlpha85),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, Constant.deleteHeadacheType);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Center(
                      child: Text(
                        Constant.deleteHeadacheType,
                        style: TextStyle(
                          color: Constant.deleteLogRedColor,
                          fontSize: 18,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                child: Text(
                  Constant.cancel,
                  style: TextStyle(
                    color: Constant.cancelBlueColor,
                    fontSize: 18,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
        ],
      ),
    );
  }
}
