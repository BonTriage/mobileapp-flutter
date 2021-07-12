import 'package:flutter/material.dart';
import 'package:mobile/models/QuestionsModel.dart';
import 'package:mobile/util/constant.dart';

class LogDayMedicationListActionSheet extends StatefulWidget {
  final List<Values> medicationValuesList;
  final Function(Values) onItemDeselect;

  const LogDayMedicationListActionSheet({Key key, this.medicationValuesList, this.onItemDeselect}) : super(key: key);

  @override
  _LogDayMedicationListActionSheetState createState() => _LogDayMedicationListActionSheetState();
}

class _LogDayMedicationListActionSheetState extends State<LogDayMedicationListActionSheet> {
  String _searchText = Constant.blankString;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.5,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Constant.backgroundTransparentColor,
            ),
            child: Column(
              children: [
                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: TextFormField(
                    onChanged: (searchText) {
                      if(searchText.trim().isNotEmpty) {
                        setState(() {
                          this._searchText = searchText;
                        });
                      }
                    },
                    style: TextStyle(
                        color: Constant.locationServiceGreen,
                        fontSize: 15,
                        fontFamily: Constant.jostMedium),
                    cursorColor: Constant.locationServiceGreen,
                    decoration: InputDecoration(
                      hintText: Constant.searchType,
                      hintStyle: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 13,
                          fontFamily: Constant.jostMedium),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Constant.locationServiceGreen),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Constant.locationServiceGreen),),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    itemCount: widget.medicationValuesList.length,
                    itemBuilder: (context, index) {
                      String medicationText = widget.medicationValuesList[index].text;
                      if(medicationText == '+') {
                        return Container();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              bool isSelected = widget.medicationValuesList[index].isSelected;
                              widget.medicationValuesList[index].isSelected = !isSelected;

                              setState(() {

                              });
                              if(!isSelected) {
                                Navigator.pop(context, widget.medicationValuesList[index]);
                              } else {
                                widget.onItemDeselect(widget.medicationValuesList[index]);
                              }
                            },
                            child: Visibility(
                              visible: (_searchText.trim().isNotEmpty)
                                  ? widget.medicationValuesList[index].text.toLowerCase().contains(_searchText.trim().toLowerCase()) : true,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 2, top: 0, right: 2),
                                color: widget.medicationValuesList[index].isSelected ? Constant.locationServiceGreen : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Text(
                                    medicationText,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: widget.medicationValuesList[index].isSelected ? Constant.bubbleChatTextView : Constant.locationServiceGreen,
                                        fontFamily: Constant.jostMedium,
                                        height: 1.2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
