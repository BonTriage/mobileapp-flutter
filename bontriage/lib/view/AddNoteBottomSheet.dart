import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class AddNoteBottomSheet extends StatefulWidget {
  final Function(String) addNoteCallback;
  final String text;

  const AddNoteBottomSheet({Key key, this.addNoteCallback, this.text}): super(key: key);

  @override
  _AddNoteBottomSheetState createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {

  TextEditingController _textEditingController;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                widget.addNoteCallback(_textEditingController.text);
                Navigator.pop(context, _textEditingController.text);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constant.chatBubbleGreen,
                ),
                child: Text(
                  Constant.save,
                  style: TextStyle(
                    fontSize: 14,
                    color: Constant.bubbleChatTextView,
                    fontFamily: Constant.jostRegular,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.only(top: 10,bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: Constant.backgroundTransparentColor
            ),
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    minLines: 5,
                    maxLines: 6,
                    onTap: () {
                      print('ontap');
                    },
                    onEditingComplete: () {
                      print('onEditingComplete');
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: Constant.jostMedium,
                        color: Constant.unselectedTextColor),
                    cursorColor: Constant.unselectedTextColor,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      hintText: 'Add A Note...',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Constant.unselectedTextColor,
                          fontFamily: Constant.jostRegular),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide: BorderSide(
                            color: Constant.backgroundTransparentColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide: BorderSide(
                            color: Constant.backgroundTransparentColor, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
