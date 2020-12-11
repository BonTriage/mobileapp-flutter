import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class MoreSexScreen extends StatefulWidget {
  @override
  _MoreSexScreenState createState() =>
      _MoreSexScreenState();
}

class _MoreSexScreenState
    extends State<MoreSexScreen> {

  List<Values> _valuesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _valuesList = [
      Values(isSelected: true, text: Constant.female),
      Values(isSelected: false, text: Constant.male),
      Values(isSelected: false, text: Constant.interSex),
      Values(isSelected: false, text: Constant.preferNotToAnswer),
    ];
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
                        Constant.sex,
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
                    Constant.toProvideDiagnosticInfo,
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
