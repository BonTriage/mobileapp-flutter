import 'package:flutter/material.dart';
import 'package:mobile/models/AddHeadacheLogModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/CircleLogOptions.dart';
import 'package:mobile/view/TimeSection.dart';
import 'package:mobile/view/sign_up_age_screen.dart';

class AddHeadacheSection extends StatefulWidget {
  final String headerText;
  final String subText;
  final String contentType;
  final double min;
  final double max;
  final List<Value> valuesList;

  const AddHeadacheSection({Key key, this.headerText, this.subText, this.contentType, this.min, this.max, this.valuesList}) : super(key: key);
  @override
  _AddHeadacheSectionState createState() => _AddHeadacheSectionState();
}

class _AddHeadacheSectionState extends State<AddHeadacheSection> {

  Widget _getSectionWidget() {
    switch(widget.contentType) {
      case 'headacheType':
        return _getWidget(CircleLogOptions(
          logOptions: widget.valuesList,
        ));
      case 'onset':
        return _getWidget(TimeSection());
      case 'severity':
        return _getWidget(SignUpAgeScreen(
          sliderValue: widget.min,
          minText: Constant.one,
          maxText: Constant.ten,
          sliderMinValue: widget.min,
          sliderMaxValue: widget.max,
          minTextLabel: Constant.mild,
          maxTextLabel: Constant.veryPainful,
          labelText: '',
          horizontalPadding: 0,
          isAnimate: false,
        ));
      case 'disability':
        return _getWidget(SignUpAgeScreen(
          sliderValue: widget.min,
          minText: Constant.one,
          maxText: Constant.ten,
          sliderMinValue: widget.min,
          sliderMaxValue: widget.max,
          minTextLabel: Constant.noneAtALL,
          maxTextLabel: Constant.totalDisability,
          labelText: '',
          horizontalPadding: 0,
          isAnimate: false,
        ));
      default:
        return Container();
    }
  }

  Widget _getWidget(Widget mainWidget) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.headerText,
            style: TextStyle(
                fontSize: 18,
                color: Constant.chatBubbleGreen,
                fontFamily: Constant.jostMedium
            ),
          ),
        ),
        SizedBox(height: 7,),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.subText,
            style: TextStyle(
                fontSize: 14,
                color: Constant.locationServiceGreen,
                fontFamily: Constant.jostRegular
            ),
          ),
        ),
        SizedBox(height: 10,),
        mainWidget,
        Divider(
          height: 40,
          thickness: 0.5,
          color: Constant.chatBubbleGreen,
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return _getSectionWidget();
  }
}
