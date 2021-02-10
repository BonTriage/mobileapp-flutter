import 'package:flutter/material.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/util/constant.dart';

class CompassHeadacheTypeActionSheet extends StatefulWidget {
  final List<HeadacheListDataModel> headacheListModelData;

  CompassHeadacheTypeActionSheet({this.headacheListModelData});

  @override
  _CompassHeadacheTypeActionSheetState createState() =>
      _CompassHeadacheTypeActionSheetState();
}

class _CompassHeadacheTypeActionSheetState
    extends State<CompassHeadacheTypeActionSheet> {
  List<String> _radioList;
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

    _dropDownValue = widget.headacheListModelData[0].text;

    var userSelectedHeadache = widget.headacheListModelData
        .firstWhere((element) => element.isSelected, orElse: () => null);
    if (userSelectedHeadache != null) {
      _value = userSelectedHeadache.text;
    } else {
      _value = widget.headacheListModelData[0].text;
    }

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
          SizedBox(
            height: 10,
          ),
          Text(
            Constant.selectTheSavedHeadacheType,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Constant.jostRegular,
              fontSize: 14,
              color: Constant.locationServiceGreen,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.headacheListModelData.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Constant.locationServiceGreen,
                      ),
                      child: Radio(
                        value: widget.headacheListModelData[index].text,
                        activeColor: Constant.locationServiceGreen,
                        hoverColor: Constant.locationServiceGreen,
                        focusColor: Constant.locationServiceGreen,
                        groupValue: _value,
                        onChanged: (String value) {
                          widget.headacheListModelData[index].isSelected = true;
                          Navigator.pop(context, value);
                        },
                      ),
                    ),
                    Text(
                      widget.headacheListModelData[index].text,
                      style: _textStyle,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    List<DropdownMenuItem<String>> dropDownMenuItemList = [];

    widget.headacheListModelData.forEach((element) {
      dropDownMenuItemList.add(DropdownMenuItem(
        value: element.text,
        child: Text(element.text),
      ));
    });

    return dropDownMenuItemList;
  }
}
