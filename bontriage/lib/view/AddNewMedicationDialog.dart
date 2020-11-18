import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class AddNewMedicationDialog extends StatefulWidget {
  @override
  _AddNewMedicationDialogState createState() => _AddNewMedicationDialogState();
}

class _AddNewMedicationDialogState extends State<AddNewMedicationDialog> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 30
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
              color: Constant.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Medication',
                        style: TextStyle(
                          color: Constant.chatBubbleGreen,
                          fontFamily: Constant.jostMedium,
                          fontSize: 16
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Image(
                        image: AssetImage(Constant.closeIcon),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                TextField(
                  style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontSize: 15,
                      fontFamily: Constant.jostMedium),
                  cursorColor: Constant.chatBubbleGreen,
                  decoration: InputDecoration(
                    hintText: 'Tap to Type your medication',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(50, 175, 215, 148),
                        fontSize: 15,
                        fontFamily: Constant.jostMedium),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Constant.chatBubbleGreen)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Constant.chatBubbleGreen)),
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingWidget(
                      onPressed: (){},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Constant.chatBubbleGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            Constant.submit,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
