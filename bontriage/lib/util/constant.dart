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
  static String partTwoOnBoardScreenRouter = '/partTwoOnBoardScreenRouter';

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

  static String welcomePersonalizedHeadacheFirstTextView =
      'Welcome to your personalized Headache Compass! The number you see in the middle is your current Headache Score-the lower the number, the better';

  static String welcomePersonalizedHeadacheSecondTextView =
      'Throughout your journey with MigraineMentor, you will work on shrinking the size and changing the shape of your compass to lower your Headache Score.';

  static String welcomePersonalizedHeadacheThirdTextView =
      'Your Compass is generated based on Intensity, duration, disability, frequency-the four main parameters that headache specialists evaluate when diagnosing migraines and headache .';

  static String welcomePersonalizedHeadacheFourthTextView =
      'As you get better at managing your headache, you will learn to use the compass to see the impact of different measures like exposure to a possible trigger or starting a new medications.';

  static String welcomePersonalizedHeadacheFifthTextView =
      'To learn more about each measurement, try clicking on any labels of the below.';


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
  static String yearsOld = 'years old';
  static String days = 'days';
  static String hours = 'hours';
  static String blankString = '';
  static String atWhatAge = 'At what age did you first experience headaches?';
  static String selectOne = 'Select one';
  static String yes = 'Yes';
  static String no = 'No';
  static String times = 'times';
  static String lessThanFiveMinutes = 'Less than 5 minutes';
  static String fiveToTenMinutes = '5 to 10 minutes';
  static String tenToThirtyMinutes = '10 to 30 minutes';
  static String moreThanThirtyMinutes = 'More than 30 minutes';
  static String fewSecAtATime = 'Only a few seconds at a time';
  static String fewSecUpTo20Min = 'A few seconds up to a 20 minutes';
  static String moreThan20Min = 'More than 20 minutes, but always less than 3 hours';
  static String moreThan3To4Hours = 'More than 3-4 hours';
  static String alwaysOneSide = 'Always on one side';
  static String usuallyOnOneSide = 'Usually on one side, but sometimes on the other';
  static String usuallyOnBothSide = 'Usually on both sides';
  static String headacheChanged = 'Have your headaches changed significantly in the last year?';
  static String howManyTimes = 'How many times have you had this headache in the past?';
  static String didYourHeadacheStart = 'Did your headaches start following a major event (i.e. trauma, stress, illness, school, start of menses)?';
  static String isYourHeadache = 'Is your headache present much of the day, more than 15 days per month?';
  static String separateHeadachesPerDay = 'Do you get 2 or more separate headaches per day?';
  static String headachesFrequentForDays = 'Are your headaches frequent for days to weeks, then disappear for weeks to months, then become frequent again?';
  static String headachesOccurSeveralDays = 'Do your headaches occur several days or more per week for many months or years without a break for at least 4 weeks per year?';
  static String headachesBuild = 'How quickly do your headaches build to maximum severity?';
  static String headacheLast = 'If untreated, how long does your typical headache last?';
  static String experienceYourHeadache = 'Where do you experience your headache?';
  static String isYourHeadacheWorse = 'Is your headache worse with changes in position?';
  static String headacheStartDuring = 'Does your headache start during or after exertion or straining?';

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
  static Color selectTextColor = Color.fromARGB(50, 175, 215, 148);

  //images
  static String userAvatar = 'images/user_avatar.png';
  static String closeIcon = 'images/close_icon.png';
  static String volumeOn = 'images/volume_on.png';
  static String volumeOff = 'images/volume_off.png';

  //fontFamily
  static String futuraMaxiLight = "FuturaMaxiLight";
}
