import 'package:mobile/models/LocalQuestionnaire.dart';
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
          "$QUESTION_TAG TEXT"
          "$USER_SCREEN_POSITION INT"
          ")");
      batch.execute("CREATE TABLE $TABLE_QUESTIONNAIRES ("
          "$EVENT_TYPE TEXT PRIMARY KEY,"
          "$QUESTION_TAG TEXT,"
          "$QUESTIONNAIRES TEXT,"
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
    var userProgressDetail = await db
        .query(TABLE_USER_PROGRESS, columns: [USER_ID, STEP, QUESTION_TAG,USER_SCREEN_POSITION]);
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

  Future<List<LocalQuestionnaire>> getQuestionnaire() async {
    final db = await database;
    List<LocalQuestionnaire> localQuestionnaire = List<LocalQuestionnaire>();
    var localQuestionnaireData = await db.query(TABLE_QUESTIONNAIRES,
        columns: [EVENT_TYPE, QUESTIONNAIRES, SELECTED_ANSWERS]);
    localQuestionnaireData.forEach((currentQuestionnaire) {
      LocalQuestionnaire questionnaire =
          LocalQuestionnaire.fromJson(currentQuestionnaire);
      localQuestionnaire.add(questionnaire);
    });
    return localQuestionnaire;
  }

  void insertSelectedAnswers(String answer, String eventType) async {
    final db = await database;
    await db.rawInsert(
        'INSERT INTO $TABLE_QUESTIONNAIRES($SELECTED_ANSWERS) VALUES($answer) WHERE $EVENT_TYPE = $eventType');
  }

  void updateSelectedAnswers(String selectedAnswer, String eventType) async {
    Map<String, dynamic> map = {SELECTED_ANSWERS: selectedAnswer};
    final db = await database;
    await db.update(
      TABLE_QUESTIONNAIRES,
      map,
      where: "$EVENT_TYPE = ?",
      whereArgs: [eventType],
    );
  }

  Future<bool> isDatabaseExist() async {
    var localDir = await getDatabasesPath();
    var dbPath = join(localDir, "bonTriageDB.db");
    return await databaseExists(dbPath);
  }
}
