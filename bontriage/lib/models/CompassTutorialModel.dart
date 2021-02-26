class CompassTutorialModel {
  DateTime currentDateTime;
  int previousMonthIntensity;
  int currentMonthIntensity;
  int previousMonthDisability;
  int currentMonthDisability;
  int previousMonthFrequency;
  int currentMonthFrequency;
  int previousMonthDuration;
  int currentMonthDuration;
  bool isFromOnBoard;

  CompassTutorialModel({
    this.currentDateTime,
    this.previousMonthIntensity,
    this.currentMonthIntensity,
    this.previousMonthDisability,
    this.currentMonthDisability,
    this.previousMonthFrequency,
    this.currentMonthFrequency,
    this.previousMonthDuration,
    this.currentMonthDuration,
    this.isFromOnBoard = false,
  });
}