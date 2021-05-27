import 'dart:io';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class CriticalUpdateVersionDialog extends StatefulWidget {
  final String errorMessage;

  const CriticalUpdateVersionDialog({Key key, @required this.errorMessage})
      : super(key: key);

  @override
  _CriticalUpdateVersionDialogState createState() =>
      _CriticalUpdateVersionDialogState();
}

class _CriticalUpdateVersionDialogState
    extends State<CriticalUpdateVersionDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Constant.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                'Update Required!',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Constant.chatBubbleGreen,
                                    fontFamily: Constant.jostMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.jostMedium,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: BouncingWidget(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            Utils.customLaunch('https://apps.apple.com/us/app/bontriage-headache-compass/id1118593468');
                          } else {
                            Utils.customLaunch('https://apps.apple.com/us/app/bontriage-headache-compass/id1118593468');
                          }
                        },
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Constant.chatBubbleGreen,
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                                color: Constant.bubbleChatTextView,
                                fontSize: 14,
                                fontFamily: Constant.jostMedium),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
