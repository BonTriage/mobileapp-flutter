import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class AddNewMedicationDialog extends StatefulWidget {
  final Function(String) onSubmitClickedCallback;

  const AddNewMedicationDialog({Key key, this.onSubmitClickedCallback}) : super(key: key);

  @override
  _AddNewMedicationDialogState createState() => _AddNewMedicationDialogState();
}

class _AddNewMedicationDialogState extends State<AddNewMedicationDialog> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: Constant.backgroundTransparentColor),
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
                            fontSize: 16),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
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
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _textEditingController,
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingWidget(
                      onPressed: () {
                        //Navigator.pop(context, _textEditingController.text);
                        widget.onSubmitClickedCallback(_textEditingController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
