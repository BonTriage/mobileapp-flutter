import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class LogDayDoubleTapDialog extends StatefulWidget {
  @override
  _LogDayDoubleTapDialogState createState() => _LogDayDoubleTapDialogState();
}

class _LogDayDoubleTapDialogState extends State<LogDayDoubleTapDialog> {
  bool isDoubleTapped = false;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.45,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              SizedBox(height: 5,),
              Text(
                Constant.logDayEvenFaster,
                style: TextStyle(
                  fontSize: 16,
                  color: Constant.chatBubbleGreen,
                  fontFamily: Constant.jostMedium
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    isDoubleTapped ? Constant.doubleTappedItems : Constant.whenYouAreLoggingYourDay,
                    style: TextStyle(
                      color: Constant.locationServiceGreen,
                      fontSize: 13,
                      fontFamily: Constant.jostRegular,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      if(!isDoubleTapped) {
                        setState(() {
                          isDoubleTapped = true;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(10),
                      width: 67,
                      height: 67,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isDoubleTapped ? Constant.doubleTapTextColor : Constant.chatBubbleGreen, width: 2),
                          color: isDoubleTapped
                              ? Constant.chatBubbleGreen
                              : Colors.transparent),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            isDoubleTapped ? Constant.gotIt : Constant.tryDoubleTappingMe,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDoubleTapped
                                  ? Constant.bubbleChatTextView
                                  : Constant.locationServiceGreen,
                              fontFamily: Constant.jostMedium,
                              fontWeight: FontWeight.w500,
                            ),
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
    );
  }
}
