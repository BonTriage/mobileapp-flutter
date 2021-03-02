import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class ConfirmationDialog extends StatefulWidget {
  final String dialogContent;
  final String dialogTitle;

  const ConfirmationDialog({Key key, @required this.dialogContent, this.dialogTitle}) : super(key: key);

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Constant.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10,),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.dialogTitle ?? 'Alert!',
                            style: TextStyle(
                                fontSize: 18,
                                color: Constant.chatBubbleGreen,
                                fontFamily: Constant.jostMedium
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  widget.dialogContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Constant.chatBubbleGreen,
                    fontFamily: Constant.jostRegular,
                  ),
                ),
                SizedBox(height: 20,),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Constant.chatBubbleGreen,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context, 'Yes');
                        },
                        child: Center(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: Constant.jostMedium,
                              fontSize: 14,
                              color: Constant.chatBubbleGreen
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 0.5,
                      color: Constant.chatBubbleGreen,
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context, 'No');
                        },
                        child: Center(
                          child: Text(
                            'No',
                            style: TextStyle(
                                fontFamily: Constant.jostMedium,
                                fontSize: 14,
                                color: Constant.chatBubbleGreen
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

