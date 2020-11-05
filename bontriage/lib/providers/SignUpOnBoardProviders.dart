import 'dart:convert';

import 'package:mobile/models/LocalQuestionnaire.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';

import 'package:mobile/models/UserAddHeadacheLogModel.dart';

import 'package:mobile/models/LogDayQuestionnaire.dart';

import 'package:mobile/models/UserProgressDataModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SignUpOnBoardProviders {
  static const String TABLE_USER_PROGRESS = "user_progress";
  static const String USER_ID = "userId";
  static const String STEP = "step";
  static const String QUESTION_TAG = "questionTag";
  static const String TABLE_QUESTIONNAIRES = "questionnaire";
  static const String EVENT_TYPE = "event_type";
  static const String QUESTIONNAIRES = "questionnaires";
  static const String SELECTED_ANSWERS = "selectedAnswers";
  static const String USER_SCREEN_POSITION = "userScreenPosition";

  static const String TABLE_ADD_HEADACHE = "addHeadache";
  static const String HEADACHE_TYPE = "headacheType";
  static const String HEADACHE_START_DATE = "headacheStartDate";
  static const String HEADACHE_START_TIME = "headacheStartTime";
  static const String HEADACHE_END_DATE = "headacheEndDate";
  static const String HEADACHE_END_TIME = "headacheEndTime";
  static const String HEADACHE_INTENSITY = "headacheIntensity";
  static const String HEADACHE_DISABILITY = "headacheDisability";
  static const String HEADACHE_NOTE = "headacheNote";
  static const String HEADACHE_ONGOING = "headacheOnGoing";

  //For Log Day Screen
  static const String TABLE_LOG_DAY = "tableLogDay";

  SignUpOnBoardProviders._();

  static final SignUpOnBoardProviders db = SignUpOnBoardProviders._();

  Database _database;

  /// Database getter method used to get the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, 'bonTriageDB.db');
    if (await databaseExists(dbPath)) {
      return await openDatabase(dbPath);
    }

    return await openDatabase(dbPath, version: 1,
        onCreate: (Database database, int version) async {
      Batch batch = database.batch();
      batch.execute("CREATE TABLE $TABLE_USER_PROGRESS ("
          "$USER_ID TEXT PRIMARY KEY,"
          "$STEP TEXT,"
          "$QUESTION_TAG TEXT,"
          "$USER_SCREEN_POSITION integer"
          ")");
      batch.execute("CREATE TABLE $TABLE_QUESTIONNAIRES ("
          "$EVENT_TYPE TEXT PRIMARY KEY,"
          "$QUESTION_TAG TEXT,"
          "$QUESTIONNAIRES TEXT,"
          "$SELECTED_ANSWERS TEXT"
          ")");

      batch.execute("CREATE TABLE $TABLE_ADD_HEADACHE ("
          "$USER_ID TEXT PRIMARY KEY,"
          "$SELECTED_ANSWERS TEXT"
          ")");
      batch.execute("CREATE TABLE $TABLE_LOG_DAY ("
          "$USER_ID TEXT PRIMARY KEY,"
          "$SELECTED_ANSWERS TEXT"
          ")");
      await batch.commit();
    });
  }

  Future<UserProgressDataModel> insertUserProgress(
      UserProgressDataModel userProgressDataModel) async {
    final db = await database;
    await db.insert(TABLE_USER_PROGRESS, userProgressDataModel.toMap());
    return userProgressDataModel;
  }

  void updateUserProgress(UserProgressDataModel userProgressDataModel) async {
    final db = await database;
    await db.update(
      TABLE_USER_PROGRESS,
      userProgressDataModel.toMap(),
      where: "$USER_ID = ?",
      whereArgs: [userProgressDataModel.userId],
    );
  }

  Future<int> checkUserProgressDataAvailable(String tableName) async {
    final db = await database;
    var count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
    return count;
  }

  Future<UserProgressDataModel> getUserProgress() async {
    final db = await database;
    UserProgressDataModel userProgress;
    var userProgressDetail = await db.query(TABLE_USER_PROGRESS,
        columns: [USER_ID, STEP, QUESTION_TAG, USER_SCREEN_POSITION]);
    userProgressDetail.forEach((userProgressDetail) {
      userProgress = UserProgressDataModel.fromMap(userProgressDetail);
    });
    return userProgress;
  }

  Future<LocalQuestionnaire> insertQuestionnaire(
      LocalQuestionnaire questionnaire) async {
    final db = await database;
    await db.insert(TABLE_QUESTIONNAIRES, questionnaire.toMap());
    return questionnaire;
  }

  Future<List<LocalQuestionnaire>> getQuestionnaire(String eventType) async {
    final db = await database;
    List<LocalQuestionnaire> localQuestionnaire = List<LocalQuestionnaire>();
    try {
      var localQuestionnaireData = await db.rawQuery(
          "SELECT * FROM $TABLE_QUESTIONNAIRES WHERE $EVENT_TYPE = $eventType");

      localQuestionnaireData.forEach((currentQuestionnaire) {
        LocalQuestionnaire questionnaire =
            LocalQuestionnaire.fromJson(currentQuestionnaire);
        localQuestionnaire.add(questionnaire);
      });
    } catch (e) {
      print(e.toString());
    }
    var localQuestionnaireData = await db.query(TABLE_QUESTIONNAIRES,
        columns: [EVENT_TYPE, QUESTIONNAIRES, SELECTED_ANSWERS]);

    return localQuestionnaire;
  }

  void insertSelectedAnswers(String answer, String eventType) async {
    final db = await database;
    await db.rawInsert(
        'INSERT INTO $TABLE_QUESTIONNAIRES($SELECTED_ANSWERS) VALUES($answer) WHERE $EVENT_TYPE = $eventType');
  }

  void updateSelectedAnswers(SignUpOnBoardSelectedAnswersModel selectedAnswer, String eventType) async {
    Map<String, dynamic> map = {
      SELECTED_ANSWERS: jsonEncode(selectedAnswer.selectedAnswers)
    };
    final db = await database;

    /*await db.update(
      TABLE_QUESTIONNAIRES,
      map,
      where: "$EVENT_TYPE = ?",
      whereArgs: [eventType],
    );*/

    List<Map> selectedAnswerMapData = await db.rawQuery('SELECT * FROM $TABLE_QUESTIONNAIRES WHERE $EVENT_TYPE = $eventType');


    await db.update(
      TABLE_QUESTIONNAIRES,
      map,
      where: "$EVENT_TYPE = ?",
      whereArgs: [eventType],
    );

    List<Map> selectedAnswerMapData1 = await db.rawQuery('SELECT * FROM $TABLE_QUESTIONNAIRES WHERE $EVENT_TYPE = $eventType');

    print(selectedAnswerMapData1);
  }

  Future<bool> isDatabaseExist() async {
    var localDir = await getDatabasesPath();
    var dbPath = join(localDir, "bonTriageDB.db");
    return await databaseExists(dbPath);
  }

  Future<UserAddHeadacheLogModel> insertAddHeadacheDetails(
      UserAddHeadacheLogModel userAddHeadacheLogModel) async {
    final db = await database;
    await db.insert(TABLE_ADD_HEADACHE, userAddHeadacheLogModel.toMap());
    return userAddHeadacheLogModel;
  }

  void updateAddHeadacheDetails(
      UserAddHeadacheLogModel userAddHeadacheLogModel) async {
    final db = await database;
    await db.update(
      TABLE_ADD_HEADACHE,
      userAddHeadacheLogModel.toMap(),
      where: "$USER_ID = ?",
      whereArgs: [userAddHeadacheLogModel.userId],
    );
  }

  Future<List<Map>> getUserHeadacheData(String userId) async {
    final db = await database;
    List<Map> logDayQuestionnaire;
    try {
      logDayQuestionnaire = await db.rawQuery(
          "SELECT * FROM $TABLE_ADD_HEADACHE WHERE $USER_ID = $userId");
    } catch (e) {
      print(e.toString());
    }
    print(logDayQuestionnaire);
    return logDayQuestionnaire;
  }

  void updateLogDayData(String selectedAnswers, String userId) async {
    final db = await database;
    await db.update(
      TABLE_LOG_DAY,
      {SELECTED_ANSWERS: selectedAnswers},
      where: "$USER_ID = ?",
      whereArgs: [userId],
    );
    print("Log updated");
  }

  Future<List<Map>> getLogDayData(String userId) async {
    final db = await database;
    List<Map> logDayQuestionnaire;
    try {
      logDayQuestionnaire = await db
          .rawQuery("SELECT * FROM $TABLE_LOG_DAY WHERE $USER_ID = $userId");
    } catch (e) {
      print(e.toString());
    }
    print(logDayQuestionnaire);
    return logDayQuestionnaire;
  }

  Future<LogDayQuestionnaire> insertLogDayData(
      LogDayQuestionnaire logDayQuestionnaire) async {
    final db = await database;
    await db.insert(TABLE_LOG_DAY, logDayQuestionnaire.toMap());
    return logDayQuestionnaire;
  }

  Future<void> deleteAllUserLogDayData() async{
    final db = await database;
    await db.delete(TABLE_LOG_DAY);
  }

  Future<List<Map>> getAllSelectedAnswers(String eventType) async {
    final db = await database;

    List<Map> selectedAnswerMapData = await db.rawQuery(
        'SELECT * FROM $TABLE_QUESTIONNAIRES WHERE $EVENT_TYPE = $eventType');

    var kjgnj = SignUpOnBoardSelectedAnswersModel.fromJson(selectedAnswerMapData[0]);
    print(kjgnj);


    return selectedAnswerMapData;
  }
}
