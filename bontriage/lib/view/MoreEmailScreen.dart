import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class MoreEmailScreen extends StatefulWidget {
  final List<SelectedAnswers> selectedAnswerList;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;

  const MoreEmailScreen({Key key, this.selectedAnswerList, this.openActionSheetCallback}) : super(key: key);

  @override
  _MoreEmailScreenState createState() => _MoreEmailScreenState();
}

class _MoreEmailScreenState extends State<MoreEmailScreen> with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  SelectedAnswers _selectedAnswers;
  String _initialNameValue;
  bool _isShowAlert = false;
  String _errorMessage = Constant.blankString;

  @override
  void initState() {
    super.initState();
    _initialNameValue = '';
    _selectedAnswers = widget.selectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileEmailTag, orElse: () => null);

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
                              Constant.email,
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
                          hintText: 'Tap to type your email',
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
                        'Tap to type your email',
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 14,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      vsync: this,
                      child: Visibility(
                        visible: _isShowAlert,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 10),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(Constant.warningPink),
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _errorMessage,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(Constant.minTextScaleFactor, Constant.maxTextScaleFactor),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Constant.pinkTriggerColor,
                                    fontFamily: Constant.jostRegular),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
    FocusScope.of(context).requestFocus(FocusNode());
    if (_initialNameValue != _textEditingController.text.trim() && _textEditingController.text.trim().isNotEmpty) {
      var result = await widget.openActionSheetCallback(Constant.saveAndExitActionSheet, null);
      if(Utils.validateEmail(_textEditingController.text.trim())) {
        if (result != null) {
          if(result == Constant.saveAndExit) {
            _selectedAnswers.answer = _textEditingController.text.trim();
          }
          Navigator.pop(context, result == Constant.saveAndExit);
        }
      } else {
        setState(() {
          _isShowAlert = true;
          _errorMessage = 'Please enter valid email.';
        });
      }
    } else {
      Navigator.pop(context);
    }
  }
}
