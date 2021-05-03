import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';

class MoreNameScreen extends StatefulWidget {
  final List<SelectedAnswers> selectedAnswerList;
  final Future<dynamic> Function(String,dynamic) openActionSheetCallback;
  const MoreNameScreen({Key key, @required this.selectedAnswerList, @required this.openActionSheetCallback}): super(key: key);

  @override
  _MoreNameScreenState createState() =>
      _MoreNameScreenState();
}

class _MoreNameScreenState
    extends State<MoreNameScreen> {

  TextEditingController _textEditingController;
  SelectedAnswers _selectedAnswers;
  String _initialNameValue;

  @override
  void initState() {
    super.initState();
    _initialNameValue = '';
    _selectedAnswers = widget.selectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileFirstNameTag, orElse: () => null);

    _textEditingController = TextEditingController();

    if(_selectedAnswers != null) {
      _initialNameValue = _selectedAnswers.answer;
      _textEditingController.text = _initialNameValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _openSaveAndExitActionSheet();
        return false;
      },
      child: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        //Navigator.of(context).pop();
                        _openSaveAndExitActionSheet();
                      },
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constant.moreBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Image(
                              width: 20,
                              height: 20,
                              image: AssetImage(Constant.leftArrow),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              Constant.name,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 16,
                                  fontFamily: Constant.jostMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _textEditingController,
                        onChanged: (value) {
                          /*if(value.isNotEmpty) {
                            _selectedAnswers.answer = value;
                          } else {
                            _textEditingController.text = _initialNameValue;
                            //_selectedAnswers.answer = _initialNameValue;
                          }*/
                        },
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 15,
                            fontFamily: Constant.jostMedium),
                        cursorColor: Constant.locationServiceGreen,
                        decoration: InputDecoration(
                          hintText: Constant.nameHint,
                          hintStyle: TextStyle(
                              color: Constant.locationServiceGreen.withOpacity(0.5),
                              fontSize: 15,
                              fontFamily: Constant.jostMedium),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Constant.locationServiceGreen)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Constant.locationServiceGreen)),
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Constant.tapToTypeYourName,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 14,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSaveAndExitActionSheet() async {
    if (_initialNameValue != _textEditingController.text && _textEditingController.text.trim().isNotEmpty) {
      var result = await widget.openActionSheetCallback(Constant.saveAndExitActionSheet,null);
      if (result != null) {
        if(result == Constant.saveAndExit) {
          _selectedAnswers.answer = _textEditingController.text;
        }
        Navigator.pop(context, result == Constant.saveAndExit);
      }
    } else {
      Navigator.pop(context);
    }
  }
}
