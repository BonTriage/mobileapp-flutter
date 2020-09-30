import 'package:flutter/material.dart';
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

  const AddHeadacheSection({Key key, this.headerText, this.subText, this.contentType, this.min, this.max}) : super(key: key);
  @override
  _AddHeadacheSectionState createState() => _AddHeadacheSectionState();
}

class _AddHeadacheSectionState extends State<AddHeadacheSection> {

  Widget _getSectionWidget() {
    switch(widget.contentType) {
      case 'headacheType':
        return CircleLogOptions(
          logOptions: [
            'abc',
            'abc',
            'abc',
            'abc',
            'abc',
            'abc',
            'abc',
            'abc',
          ],
        );
      case 'onset':
        return TimeSection();
      case 'severity':
        return SignUpAgeScreen(
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
        );
      case 'disability':
        return SignUpAgeScreen(
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
        );
      default:
        return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
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
        _getSectionWidget(),
        Divider(
          height: 40,
          thickness: 0.5,
          color: Constant.chatBubbleGreen,
        ),
      ],
    );
  }
}
