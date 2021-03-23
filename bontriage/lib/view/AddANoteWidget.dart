import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';

import 'AddNoteBottomSheet.dart';

class AddANoteWidget extends StatefulWidget {
  final List<SelectedAnswers> selectedAnswerList;
  final String noteTag;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AddANoteWidget({Key key, this.selectedAnswerList, this.scaffoldKey, this.noteTag}): super(key: key);

  @override
  _AddANoteWidgetState createState() => _AddANoteWidgetState();
}

class _AddANoteWidgetState extends State<AddANoteWidget> {

  String text;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          _showAddNoteBottomSheet();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15),
          child: _getNoteWidget(),
        ),
      ),
    );
  }

  Widget _getNoteWidget() {
    SelectedAnswers headacheNoteSelectedAnswer = widget.selectedAnswerList.firstWhere((element) => element.questionTag == widget.noteTag, orElse: () => null);
    if (headacheNoteSelectedAnswer == null) {
      return Text(
        Constant.addANote,
        style: TextStyle(
          fontSize: 16,
          color: Constant
              .addCustomNotificationTextColor,
          fontFamily: Constant.jostRegular,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit,
            color: Constant.addCustomNotificationTextColor,
            size: 16,
          ),
          SizedBox(width: 5,),
          Text(
            Constant.viewEditNote,
            style: TextStyle(
              fontSize: 16,
              color: Constant
                  .addCustomNotificationTextColor,
              fontFamily: Constant.jostRegular,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }

  void _showAddNoteBottomSheet() {
    FocusScope.of(context).requestFocus(FocusNode());
    text = '';
    SelectedAnswers noteSelectedAnswer = widget.selectedAnswerList.firstWhere((element) => element.questionTag == widget.noteTag, orElse: () => null);
    if (noteSelectedAnswer != null) {
      text = noteSelectedAnswer.answer ?? '';
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => AddNoteBottomSheet(
          text: text,
          addNoteCallback: (note) {
            if(note != null) {
              if(note is String) {
                if(note.trim() != '') {
                  SelectedAnswers noteSelectedAnswer = widget.selectedAnswerList.firstWhere((element) => element.questionTag == widget.noteTag, orElse: () => null);
                  if (noteSelectedAnswer == null)
                    widget.selectedAnswerList.add(SelectedAnswers(questionTag: widget.noteTag, answer: note));
                  else
                    noteSelectedAnswer.answer = note;

                  setState(() {});
                }
              }
            }
          },
        ));
  }
}
