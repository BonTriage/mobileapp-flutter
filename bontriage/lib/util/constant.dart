import 'package:flutter/cupertino.dart';

class Constant {
  static String splashRouter = '/splash';
  static String homeRouter = '/home';
  static String loginRouter = '/login';
  static String signUpRouter = '/signUP';
  static String signUpOnBoardSplashRouter = '/signUpOnBoardSplash';
  static String signUpOnBoardStartAssessmentRouter =
      '/signUpOnBoardStartAssessment';
  static String signUpFirstStepHeadacheResultRouter =
      '/signUpFirstStepHeadacheResult';
  static String signUpOnBoardPersonalizedHeadacheResultRouter =
      '/signUpOnBoardPersonalizedHeadacheResult';
  static String signUpNameScreenRouter = '/signUpNameScreen';
  static String signUpAgeScreenRouter = '/signUpAgeScreen';
  static String signUpLocationServiceRouter = '/signUpLocationService';
  static String signUpOnBoardHeadacheQuestionRouter = '/signUpOnBoardHeadacheQuestion';

  //strings
  static String welcomeToAurora = "Welcome to Aurora";
  static String developedByATeam =
      'Developed by a team of board-certified migraine and headache specialists, computer scientists, engineers, and mathematicians, Aurora is an important part of an advanced headache diagnosis and treatment system. By downloading this tool, you have already taken the first step toward better managing your headaches.';
  static String trackRightData = 'Track the right data';
  static String mostHeadacheTracking =
      'Unlinke most headache tracking apps, Aurora utilizes big data - weather changes, pollen counts, sleep quality, exercise, and self-logged triggers - to build your personalized headache risk profile (HRP).';
  static String conquerYourHeadaches = 'Conquer your headaches';
  static String withRegularUse =
      'With regular use, Aurora creates a predictive model that can alert you when you are at risk for headaches and can even suggest steps to avoid them you can also get reminders to take your daily medicine or send an update to your doctor to let them know how you are doing.';
  static String next = 'Next';
  static String getGoing = 'Get Going!';
  static String firstBasics = 'First, a few basics...';
  static String whatShouldICallYou = 'What should I call you?';
  static String howOld = 'How old are you?';
  static String likeToEnableLocationServices =
      'Would you like to enable Location Services?';
  static String back = 'Back';
  static String nameHint = 'Tap to type your name';
  static String enableLocationServices = 'Enable Location Services';
  static String enableLocationRecommended =
      'Enabling Location Services is highly recommended since it allows us to analyze environmental factors that may affect your headaches.';
  static String welcomeMigraineMentorTextView =
      'Welcome to MigraineMentor! Unlike other migraine trackers, relaxation exercise, or triggers-based apps, MigraineMentor is like having a headache expert in your pocket.';
  static String migraineMentorHelpTextView =
      'MigraineMentor can help you diagnose your headache type, learn how to manage your headache, and assess whether you are on the right track with your treatment, lifestyle, and prevention.if that\'s what you\'re looking for, and are willing to put in a little time and effort,you\'ve come to the right app.';
  static String compassDiagramTextView =
      'Surprised\'? This is your Compass Diagram, and the number in the middle is your current Headache Score. The lower the number, the better';

  static String startAssessment = 'Start Assessment';
  static String letsStarted = 'Let\'s get started!';
  static String personalizedHeadacheCompass = 'Generating your personalized Headache Compass...';

  static String howManyDays =
      'Over the last three months, how many days per month, on average, have you been absolutely headache free?';
  static String howManyHours =
      'Over the last three months, how many hours, on average, does a typical headache last if you don\'t treat it?';
  static String onScaleOf =
      'On a scale of 1 to 10, 1 being no pain, how bad is the pain of your typical headache, if you don\'t treat it?';
  static String howDisabled =
      'Overall, from 0-4, how disabled are you by your headaches, 0 being no disability and 4 being completely disabled?';

  //decorations
  static BoxDecoration backgroundBoxDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
        Color(0xff0E232F),
        Color(0xff0E4C47),
      ]));

//colors
  static Color backgroundColor = Color(0xff0E232F);
  static Color chatBubbleGreen = Color(0xffAFD794);
  static Color chatBubbleGreenBlue = Color.fromARGB(15, 175, 215, 148);
  static Color locationServiceGreen = Color(0xffCAD7BF);
  static Color bubbleChatTextView = Color(0xff0E1712);
  static Color chatBubbleGreenTransparent = Color(0x26AFD794);

//images
  static String userAvatar = 'images/user_avatar.png';
  static String closeIcon = 'images/close_icon.png';
  static String volumeOn = 'images/volume_on.png';
  static String volumeOff = 'images/volume_off.png';
}
