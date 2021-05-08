import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class ValidationErrorDialog extends StatefulWidget {
  final String errorMessage;
  final String errorTitle;

  const ValidationErrorDialog({Key key, @required this.errorMessage, this.errorTitle}) : super(key: key);

  @override
  _ValidationErrorDialogState createState() => _ValidationErrorDialogState();
}

class _ValidationErrorDialogState extends State<ValidationErrorDialog> {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                            Image(
                              image: AssetImage(Constant.errorGreen),
                              height: 25,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              widget.errorTitle ?? 'Error!',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Constant.chatBubbleGreen,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image(
                            image: AssetImage(Constant.closeIcon),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    widget.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.jostMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
