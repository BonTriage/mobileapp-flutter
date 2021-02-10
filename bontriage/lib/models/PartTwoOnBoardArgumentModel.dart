import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';

class PartTwoOnBoardArgumentModel {
  String eventId;
  List<SelectedAnswers> selectedAnswersList;
  String argumentName;
  bool isFromMoreScreen;

  PartTwoOnBoardArgumentModel({this.eventId, this.selectedAnswersList, this.argumentName, this.isFromMoreScreen = false});
}