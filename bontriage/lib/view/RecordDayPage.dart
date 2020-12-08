import 'package:flutter/material.dart';
import 'package:mobile/models/UserHeadacheLogDayDetailsModel.dart';
import 'package:mobile/util/constant.dart';

class RecordDayPage extends StatefulWidget {
  final bool hasData;
  final DateTime dateTime;
  final UserHeadacheLogDayDetailsModel userHeadacheLogDayDetailsModel;

  const RecordDayPage(
      {Key key,
      this.hasData = false,
      this.dateTime,
      this.userHeadacheLogDayDetailsModel})
      : super(key: key);

  @override
  _RecordDayPageState createState() => _RecordDayPageState();
}

class _RecordDayPageState extends State<RecordDayPage>
    with SingleTickerProviderStateMixin {
  GlobalKey _globalKey = GlobalKey();
  AnimationController _animationController;

  UserHeadacheLogDayDetailsModel userLogDayDetails;

  List<Widget> _getSections() {
    if (widget.hasData) {
      return [
        Visibility(
          visible: false,
          child: _getSectionWidget(
            Constant.migraineIcon,
            'Migrane',
            '3:21 hours, Intensity: 4, Disability: 3',
            '“Lorem ipsum dolor sit amet, consectetur adipiscing elit”',
            '',
          ),
        ),
        Visibility(
          visible: userLogDayDetails.headacheLogDayListData.length > 1? true :false,
          child: _getSectionWidget(
              Constant.sleepIcon,
              'Sleep',
              userLogDayDetails.headacheLogDayListData.length > 1? userLogDayDetails.headacheLogDayListData[1].logDayListData.titleInfo: "",
              '',
              ''),
        ),
        Visibility(
          visible: false,
          child: _getSectionWidget(Constant.waterDropIcon, 'Water', '4 cups',
              '', 'This is less than recommended'),
        ),
        Visibility(
        visible: userLogDayDetails.headacheLogDayListData.length > 2? true :false,
          child: _getSectionWidget(
              Constant.mealIcon,
              'Meals',
              userLogDayDetails.headacheLogDayListData.length > 2? userLogDayDetails.headacheLogDayListData[2].logDayListData.titleInfo: "",
              '',
              ''),
        ),
        Visibility(
          visible: false,
          child: _getSectionWidget(Constant.weatherIcon, 'Weather',
              '90% humidity', '', 'This is higher than usual'),
        ),
        Visibility(
          visible: userLogDayDetails.headacheLogDayListData.length > 3? true :false,
          child: _getSectionWidget(
              Constant.pillIcon,
              'Medication',
              userLogDayDetails.headacheLogDayListData.length > 3? userLogDayDetails.headacheLogDayListData[3].logDayListData.titleInfo: "",
              '',
              ''),
        ),
        Visibility(
          visible: false,
          child: Text(
            'Note:\n“Lorem ipsum dolor sit amet, consectetur adipiscing elit”',
            style: TextStyle(
                color: Constant.chatBubbleGreen60Alpha,
                fontFamily: Constant.jostRegular,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
          visible: false,
          child: FlatButton.icon(
            padding: EdgeInsets.all(0),
            onPressed: () {},
            icon: Image.asset(
              Constant.addCircleIcon,
              width: 20,
              height: 20,
            ),
            label: Text(
              'Add/Edit Info',
              style: TextStyle(
                  color: Constant.chatBubbleGreen,
                  fontFamily: Constant.jostRegular,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: false,
          child: FlatButton.icon(
            padding: EdgeInsets.all(0),
            onPressed: () {},
            icon: Image.asset(
              Constant.addCircleIcon,
              width: 20,
              height: 20,
            ),
            label: Text(
              'Add/Edit Headache',
              style: TextStyle(
                  color: Constant.chatBubbleGreen,
                  fontFamily: Constant.jostRegular,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ];
    } else {
      return [
        Text(
          'Nothing Logged!',
          style: TextStyle(
              fontSize: 18,
              color: Constant.chatBubbleGreen,
              fontWeight: FontWeight.w500,
              fontFamily: Constant.jostRegular),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Add info to better personalize your experience',
          style: TextStyle(
              fontSize: 18,
              color: Constant.chatBubbleGreen60Alpha,
              fontWeight: FontWeight.w500,
              fontFamily: Constant.jostRegular),
        ),
        Divider(
          thickness: 0.5,
          color: Constant.chatBubbleGreen,
          height: 40,
        ),
        FlatButton.icon(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          icon: Image.asset(
            Constant.addCircleIcon,
            width: 20,
            height: 20,
          ),
          label: Text(
            'Add/Edit Info',
            style: TextStyle(
                color: Constant.chatBubbleGreen,
                fontFamily: Constant.jostRegular,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(
          height: 10,
        ),
        FlatButton.icon(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          icon: Image.asset(
            Constant.addCircleIcon,
            width: 20,
            height: 20,
          ),
          label: Text(
            'Add/Edit Headache',
            style: TextStyle(
                color: Constant.chatBubbleGreen,
                fontFamily: Constant.jostRegular,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _globalKey.currentContext.findRenderObject();
      final size = renderBox.size;
      print(size);
    });

    print(widget.dateTime);

    userLogDayDetails = widget.userHeadacheLogDayDetailsModel;

    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000),
        reverseDuration: Duration(milliseconds: 1000),
        vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RecordDayPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(widget.dateTime);

    if (!_animationController.isAnimating) {
      _animationController.reverse();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        key: _globalKey,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getSections(),
        ),
      ),
    );
  }

  Widget _getSectionWidget(String imagePath, String headerText, String subText,
      String noteText, String warningText) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 20,
              width: 20,
              image: AssetImage(imagePath),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headerText,
                    style: TextStyle(
                        color: Constant.chatBubbleGreen,
                        fontFamily: Constant.jostRegular,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    subText,
                    style: TextStyle(
                        color: Constant.chatBubbleGreen60Alpha,
                        fontFamily: Constant.jostRegular,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: noteText.isNotEmpty,
                    child: Text(
                      'Note:\n$noteText',
                      style: TextStyle(
                          color: Constant.chatBubbleGreen60Alpha,
                          fontFamily: Constant.jostRegular,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: warningText.isNotEmpty,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          width: 13,
                          height: 13,
                          image: AssetImage(Constant.warningPink),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          warningText,
                          style: TextStyle(
                            color: Constant.pinkTriggerColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: Constant.jostRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          height: 30,
          thickness: 0.5,
          color: Constant.chatBubbleGreen,
        ),
      ],
    );
  }
}
