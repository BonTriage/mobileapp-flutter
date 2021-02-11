import 'package:flutter/material.dart';
import 'package:mobile/models/EditGraphViewFilterModel.dart';
import 'package:mobile/models/HeadacheListDataModel.dart';
import 'package:mobile/util/constant.dart';

class EditGraphViewBottomSheet extends StatefulWidget {
  final EditGraphViewFilterModel editGraphViewFilterModel;

  const EditGraphViewBottomSheet({Key key, this.editGraphViewFilterModel})
      : super(key: key);

  @override
  _EditGraphViewBottomSheetState createState() => _EditGraphViewBottomSheetState();
}

class _EditGraphViewBottomSheetState extends State<EditGraphViewBottomSheet> {

  List<String> _headacheTypeRadioButtonList;
  List<HeadacheListDataModel> _singleHeadacheTypeList;
  List<HeadacheListDataModel> _compareHeadacheTypeList1;
  List<HeadacheListDataModel> _compareHeadacheTypeList2;
  List<String> _otherFactorsRadioButtonList;

  String _headacheTypeRadioButtonSelected;
  String _singleHeadacheTypeSelected;
  String _compareHeadacheTypeSelected1;
  String _compareHeadacheTypeSelected2;
  String _otherFactorsSelected;

  TextStyle _headerTextStyle;
  TextStyle _radioTextStyle;
  TextStyle _dropDownTextStyle;

  @override
  void initState() {
    super.initState();

    _headerTextStyle = TextStyle(
      fontSize: 16,
      color: Constant.locationServiceGreen,
      fontFamily: Constant.jostMedium,
    );

    _headacheTypeRadioButtonList = [
      Constant.viewSingleHeadache,
      Constant.compareHeadache
    ];
    _headacheTypeRadioButtonSelected = widget.editGraphViewFilterModel.headacheTypeRadioButtonSelected;

    _singleHeadacheTypeList = widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData;
    _singleHeadacheTypeSelected = widget.editGraphViewFilterModel.singleTypeHeadacheSelected;

    _compareHeadacheTypeList1 = widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData;
    _compareHeadacheTypeSelected1 = widget.editGraphViewFilterModel.compareHeadacheTypeSelected1;

    _compareHeadacheTypeList2 = widget.editGraphViewFilterModel.recordsTrendsDataModel.headacheListModelData;
    _compareHeadacheTypeSelected2 = widget.editGraphViewFilterModel.compareHeadacheTypeSelected2;

    _otherFactorsRadioButtonList = [
      Constant.noneRadioButtonText,
      Constant.loggedBehaviors,
      Constant.loggedPotentialTriggers,
      Constant.medications,
    ];
    _otherFactorsSelected = widget.editGraphViewFilterModel.whichOtherFactorSelected;

    _radioTextStyle = TextStyle(
      fontFamily: Constant.jostRegular,
      fontSize: 14,
      color: Constant.locationServiceGreen,
    );

    _dropDownTextStyle = TextStyle(
      fontFamily: Constant.jostRegular,
      fontSize: 12,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  Constant.editGraphView,
                  style: TextStyle(
                    color: Constant.locationServiceGreen,
                    fontSize: 16,
                    fontFamily: Constant.jostMedium,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    widget.editGraphViewFilterModel.singleTypeHeadacheSelected = _singleHeadacheTypeSelected;
                    widget.editGraphViewFilterModel.compareHeadacheTypeSelected1 = _compareHeadacheTypeSelected1;
                    widget.editGraphViewFilterModel.compareHeadacheTypeSelected2 = _compareHeadacheTypeSelected2;
                    widget.editGraphViewFilterModel.whichOtherFactorSelected = _otherFactorsSelected;
                    Navigator.pop(context, Constant.success);
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
            height: 20,
          ),
          DefaultTabController(
            length: 4,
            initialIndex: widget.editGraphViewFilterModel.currentTabIndex,
            child: Container(
              padding: EdgeInsets.all(5),
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Constant.locationServiceGreen,
                ),
                color: Colors.transparent
              ),
              child: TabBar(
                onTap: (index) {

                },
                indicatorPadding: EdgeInsets.all(0),
                labelPadding: EdgeInsets.all(0),
                labelStyle: TextStyle(
                    fontSize: 14, fontFamily: Constant.jostRegular),
                //For Selected tab
                unselectedLabelStyle: TextStyle(
                    fontSize: 14, fontFamily: Constant.jostRegular),
                //For Un-selected Tabs
                labelColor: Constant.backgroundColor,
                unselectedLabelColor: Constant.locationServiceGreen,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Constant.locationServiceGreen),
                tabs: [
                  Tab(
                    text: Constant.intensity,
                  ),
                  Tab(
                    text: Constant.disability,
                  ),
                  Tab(
                    text: Constant.frequency,
                  ),
                  Tab(
                    text: Constant.duration,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(
            '${Constant.headacheType}:',
            style: _headerTextStyle,
          ),
          Row(
            children: [
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: Constant.locationServiceGreen,
                ),
                child: Radio(
                  value: _headacheTypeRadioButtonList[0],
                  activeColor: Constant.locationServiceGreen,
                  hoverColor: Constant.locationServiceGreen,
                  focusColor: Constant.locationServiceGreen,
                  groupValue: _headacheTypeRadioButtonSelected,
                  onChanged: (String value) {
                    setState(() {
                      _headacheTypeRadioButtonSelected = value;
                    });
                  },
                ),
              ),
              Text(
                _headacheTypeRadioButtonList[0],
                style: _radioTextStyle
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
                    value: _singleHeadacheTypeSelected,
                    onChanged: (value) {
                      setState(() {
                        _singleHeadacheTypeSelected = value;
                      });
                    },
                    isExpanded: true,
                    style: _dropDownTextStyle,
                    icon: Image.asset(Constant.downArrow2, height: 10, width: 10,),
                    dropdownColor: Constant.backgroundColor,
                    items: _getDropDownMenuItems(_singleHeadacheTypeList),
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
                  value: _headacheTypeRadioButtonList[1],
                  activeColor: Constant.locationServiceGreen,
                  hoverColor: Constant.locationServiceGreen,
                  focusColor: Constant.locationServiceGreen,
                  groupValue: _headacheTypeRadioButtonSelected,
                  onChanged: (String value) {
                    setState(() {
                      _headacheTypeRadioButtonSelected = value;
                    });
                  },
                ),
              ),
              Text(
                  _headacheTypeRadioButtonList[1],
                  style: _radioTextStyle
              ),
              SizedBox(width: 10,),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 15,),
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
                    value: _compareHeadacheTypeSelected1,
                    onChanged: (value) {
                      setState(() {
                        _compareHeadacheTypeSelected1 = value;
                      });
                    },
                    isExpanded: true,
                    style: _dropDownTextStyle,
                    icon: Image.asset(Constant.downArrow2, height: 10, width: 10,),
                    dropdownColor: Constant.backgroundColor,
                    items: _getDropDownMenuItems(_compareHeadacheTypeList1),
                    underline: Container(),
                  ),
                ),
              ),
              SizedBox(width: 20,),
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
                    value: _compareHeadacheTypeSelected2,
                    onChanged: (value) {
                      setState(() {
                        _compareHeadacheTypeSelected2 = value;
                      });
                    },
                    isExpanded: true,
                    style: _dropDownTextStyle,
                    icon: Image.asset(Constant.downArrow2, height: 10, width: 10,),
                    dropdownColor: Constant.backgroundColor,
                    items: _getDropDownMenuItems(_compareHeadacheTypeList2),
                    underline: Container(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Divider(
            color: Constant.locationServiceGreen,
            thickness: 0.5,
            height: 0.5,
          ),
          SizedBox(height: 10,),
          Text(
            Constant.otherFactors,
            style: _headerTextStyle,
          ),
          Column(
            children: _getOtherFactorsRadioButton(),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems(List<HeadacheListDataModel> dropDownStringList) {
    List<DropdownMenuItem<String>> dropDownMenuItemList = [];

    dropDownStringList.forEach((element) {
      dropDownMenuItemList.add(DropdownMenuItem(
        value: element.text,
        child: Text(element.text,
        ),
      ));
    });

    return dropDownMenuItemList;
  }

  List<Widget> _getOtherFactorsRadioButton() {
    List<Widget> widgetList = [];

    _otherFactorsRadioButtonList.forEach((element) {
      widgetList.add(Row(
        children: [
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Constant.locationServiceGreen,
            ),
            child: Radio(
              value: element,
              activeColor: Constant.locationServiceGreen,
              hoverColor: Constant.locationServiceGreen,
              focusColor: Constant.locationServiceGreen,
              groupValue: _otherFactorsSelected,
              onChanged: (String value) {
                setState(() {
                  _otherFactorsSelected = value;
                });
              },
            ),
          ),
          Text(
              element,
              style: _radioTextStyle
          ),
        ],
      ));
    });

    return widgetList;
  }
}
