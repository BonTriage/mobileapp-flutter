import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class CompassHeadacheTypeActionSheet extends StatefulWidget {
  @override
  _CompassHeadacheTypeActionSheetState createState() => _CompassHeadacheTypeActionSheetState();
}

class _CompassHeadacheTypeActionSheetState extends State<CompassHeadacheTypeActionSheet> {
  List<String> _radioList;
  List<String> _headacheDropDownList;

  String _value;
  String _dropDownValue;

  TextStyle _textStyle;

  @override
  void initState() {
    super.initState();

    _radioList = [
      Constant.singleHeadache,
      Constant.summaryOfAllHeadacheTypes,
    ];

    _headacheDropDownList = [
      'Headache 1',
      'Headache 2',
      'Headache 3',
      'Headache 4',
    ];
    _dropDownValue = _headacheDropDownList[0];

    _value = Constant.singleHeadache;

    _textStyle = TextStyle(
      fontFamily: Constant.jostRegular,
      fontSize: 14,
      color: Constant.locationServiceGreen,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Headache Type',
                  style: TextStyle(
                    color: Constant.locationServiceGreen,
                    fontSize: 16,
                    fontFamily: Constant.jostRegular,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    Constant.closeIcon2,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Text(
            Constant.selectTheSavedHeadacheType,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Constant.jostRegular,
              fontSize: 14,
              color: Constant.locationServiceGreen,
            ),
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: Constant.locationServiceGreen,
                ),
                child: Radio(
                  value: _radioList[0],
                  activeColor: Constant.locationServiceGreen,
                  hoverColor: Constant.locationServiceGreen,
                  focusColor: Constant.locationServiceGreen,
                  groupValue: _value,
                  onChanged: (String value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 10,),
              Text(
                Constant.singleHeadache,
                style: _textStyle,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Constant.locationServiceGreen,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton(
                    value: _dropDownValue,
                    onChanged: (value) {
                      setState(() {
                        _dropDownValue = value;
                      });
                    },
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: Constant.jostRegular,
                      color: Constant.locationServiceGreen
                    ),
                    icon: Image.asset(Constant.downArrow2, height: 10, width: 10,),
                    dropdownColor: Constant.backgroundColor,
                    items: _getDropDownMenuItems(),
                    underline: Container(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: Constant.locationServiceGreen,
                ),
                child: Radio(
                  value: _radioList[1],
                  activeColor: Constant.locationServiceGreen,
                  hoverColor: Constant.locationServiceGreen,
                  focusColor: Constant.locationServiceGreen,
                  groupValue: _value,
                  onChanged: (String value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 10,),
              Text(
                Constant.summaryOfAllHeadacheTypes,
                style: _textStyle,
              ),
            ],
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    List<DropdownMenuItem<String>> dropDownMenuItemList = [];

    _headacheDropDownList.forEach((element) {
      dropDownMenuItemList.add(DropdownMenuItem(
        value: element,
        child: Text(
          element
        ),
      ));
    });

    return dropDownMenuItemList;
  }
}
