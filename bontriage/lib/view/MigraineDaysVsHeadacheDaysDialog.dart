import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MigraineDaysVsHeadacheDaysDialog extends StatefulWidget {
  @override
  _MigraineDaysVsHeadacheDaysDialogState createState() => _MigraineDaysVsHeadacheDaysDialogState();
}

class _MigraineDaysVsHeadacheDaysDialogState extends State<MigraineDaysVsHeadacheDaysDialog> {
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
                  SizedBox(height: 10,),
                  Text(
                    Constant.migraineDaysVsHeadacheDays,
                    style: TextStyle(
                        fontSize: 16,
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.jostMedium
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    Constant.migraineDaysVsHeadacheDaysDialogText,
                    style: TextStyle(
                        color: Constant.locationServiceGreen,
                        fontSize: 14,
                        fontFamily: Constant.jostRegular,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}