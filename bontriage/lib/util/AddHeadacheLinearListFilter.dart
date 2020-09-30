
import 'package:mobile/models/AddHeadacheLogModel.dart';

class AddHeadacheLinearListFilter{
  static List<Question> getQuestionSeries(String initialQuestion ,List<Question> questionGroup){
    List<Question> localListOfDataPriority = new List<Question>();
    var nextTag = initialQuestion;
    do{
      Question model = questionGroup.firstWhere((model) => model.tag == nextTag);
      localListOfDataPriority.add(model);
      nextTag = model.next;
      questionGroup.remove(model);
    }while(nextTag != "");

    return localListOfDataPriority;
  }
}