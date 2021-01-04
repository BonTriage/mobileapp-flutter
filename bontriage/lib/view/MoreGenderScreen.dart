import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class MoreGenderScreen extends StatefulWidget {
  final String gender;

  const MoreGenderScreen({Key key, this.gender}) : super(key: key);
  @override
  _MoreGenderScreenState createState() =>
      _MoreGenderScreenState();
}

class _MoreGenderScreenState
    extends State<MoreGenderScreen> {

  List<Values> _valuesList;

  @override
  void initState() {
    super.initState();

    _valuesList = [
      Values(isSelected: true, text: Constant.woman),
      Values(isSelected: false, text: Constant.man),
      Values(isSelected: false, text: Constant.genderNonConforming),
      Values(isSelected: false, text: Constant.preferNotToAnswer),
    ];


    if(widget.gender != null && widget.gender.isNotEmpty) {
      _valuesList[0].isSelected = false;
      if (widget.gender.toLowerCase() == 'male') {
        Values genderValue = _valuesList.firstWhere((element) => element.text == Constant.man, orElse: () => null);
        if(genderValue != null) {
          genderValue.isSelected = true;
        }
      } else if (widget.gender.toLowerCase() == 'female') {
        Values genderValue = _valuesList.firstWhere((element) => element.text == Constant.woman, orElse: () => null);
        if(genderValue != null) {
          genderValue.isSelected = true;
        }
      } else {
        Values genderValue = _valuesList.firstWhere((element) => element.text == widget.gender, orElse: () => null);
        if(genderValue != null) {
          genderValue.isSelected = true;
        }
      }
    }
  }

  BoxDecoration _getBoxDecoration(int index) {
    if (!_valuesList[index].isSelected) {
      return BoxDecoration(
        border: Border.all(width: 1, color: Constant.chatBubbleGreen.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      );
    } else {
      return BoxDecoration(
          border: Border.all(width: 1, color: Constant.locationServiceGreen),
          borderRadius: BorderRadius.circular(4),
          color: Constant.locationServiceGreen);
    }
  }

  Color _getOptionTextColor(int index) {
    if (_valuesList[index].isSelected) {
      return Constant.bubbleChatTextView;
    } else {
      return Constant.locationServiceGreen;
    }
  }

  void _onOptionSelected(int index) {
    _valuesList.asMap().forEach((key, value) {
      _valuesList[key].isSelected = index == key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Constant.moreBackgroundColor,
                  ),
                  child: Row(
                    children: [
                      Image(
                        width: 20,
                        height: 20,
                        image: AssetImage(Constant.leftArrow),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        Constant.gender,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 16,
                            fontFamily: Constant.jostMedium),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  Constant.selectOne,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Constant.jostMedium,
                      color: Constant.editTextBoarderColor.withOpacity(0.5)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: _valuesList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _onOptionSelected(index);
                              });
                            },
                            child: Container(
                              decoration: _getBoxDecoration(index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  _valuesList[index].text,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _getOptionTextColor(index),
                                      fontFamily: Constant.jostRegular,
                                      height: 1.2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    Constant.selectTheGender,
                    style: TextStyle(
                        color: Constant.locationServiceGreen,
                        fontSize: 14,
                        fontFamily: Constant.jostMedium
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
