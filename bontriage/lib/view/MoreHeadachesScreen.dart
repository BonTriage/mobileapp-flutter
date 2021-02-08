import 'package:flutter/material.dart';
import 'package:mobile/blocs/MoreHeadachesBloc.dart';
import 'package:mobile/models/MoreHeadacheScreenArgumentModel.dart';
import 'package:mobile/models/PartTwoOnBoardArgumentModel.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreHeadachesScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;
  final MoreHeadacheScreenArgumentModel moreHeadacheScreenArgumentModel;
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) navigateToOtherScreenCallback;

  const MoreHeadachesScreen(
      {Key key, this.onPush, this.openActionSheetCallback, this.moreHeadacheScreenArgumentModel, this.showApiLoaderCallback, this.navigateToOtherScreenCallback})
      : super(key: key);

  @override
  _MoreHeadachesScreenState createState() => _MoreHeadachesScreenState();
}

class _MoreHeadachesScreenState extends State<MoreHeadachesScreen> {

  MoreHeadacheBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MoreHeadacheBloc();

    _listenToDeleteHeadacheStream();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constant.backgroundBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                            width: 16,
                            height: 16,
                            image: AssetImage(Constant.leftArrow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.moreHeadacheScreenArgumentModel.headacheTypeData.text,
                            style: TextStyle(
                                color: Constant.locationServiceGreen,
                                fontSize: 16,
                                fontFamily: Constant.jostRegular),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.moreBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        MoreSection(
                          text: Constant.viewReport,
                          moreStatus: '',
                          isShowDivider: true,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _bloc.initNetworkStreamController();
                            widget.showApiLoaderCallback(_bloc.networkStream, () {
                              _bloc.networkSink.add(Constant.loading);
                              _getDiagnosticAnswerList();
                            });
                            _getDiagnosticAnswerList();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constant.reCompleteInitialAssessment,
                                style: TextStyle(
                                    color: Constant.addCustomNotificationTextColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Image(
                                    width: 16,
                                    height: 16,
                                    image: AssetImage(Constant.rightArrow),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 30,
                          color: Constant.locationServiceGreen,
                        ),
                        GestureDetector(
                          onTap: () {
                            _openDeleteHeadacheActionSheet();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constant.deleteHeadacheType,
                                style: TextStyle(
                                    color: Constant.pinkTriggerColor,
                                    fontSize: 16,
                                    fontFamily: Constant.jostRegular
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Image(
                                    width: 16,
                                    height: 16,
                                    image: AssetImage(Constant.rightArrow),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      _getInfoText(),
                      style: TextStyle(
                          color: Constant.locationServiceGreen,
                          fontSize: 14,
                          fontFamily: Constant.jostMedium
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInfoText() {
    return 'Based on what you entered, it looks like your ${widget.moreHeadacheScreenArgumentModel.headacheTypeData.text} could potentially be considered by doctors to be a [Clinical Type]. This is not a diagnosis, but it is an accurate clinical impression, based on your answers, of how your headache best matches up to known headache types. If you haven’t already done so, you should see a qualified medical professional for a firm diagnosis';
  }

  void _openDeleteHeadacheActionSheet() async {
    var resultOfActionSheet = await widget.openActionSheetCallback(Constant.deleteHeadacheTypeActionSheet, null);
    if(resultOfActionSheet == Constant.deleteHeadacheType) {
      _bloc.initNetworkStreamController();
      widget.showApiLoaderCallback(_bloc.networkStream, () {
        _bloc.networkSink.add(Constant.loading);
        _bloc.callDeleteHeadacheTypeService(widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber);
      });
      _bloc.callDeleteHeadacheTypeService(widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber);
    }
  }

  void _listenToDeleteHeadacheStream() {
    _bloc.deleteHeadacheStream.listen((data) {
      if(data == 'Event Deleted') {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pop(context, data);
        });
      }
    });
  }

  void _getDiagnosticAnswerList() async {
    List<SelectedAnswers> selectedAnswerList = await _bloc.fetchDiagnosticAnswers(widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber);
    if(selectedAnswerList.length > 0) {
      Future.delayed(Duration(milliseconds: 500), () {
        widget.navigateToOtherScreenCallback(Constant.partTwoOnBoardScreenRouter, PartTwoOnBoardArgumentModel(
          eventId: widget.moreHeadacheScreenArgumentModel.headacheTypeData.valueNumber,
          selectedAnswersList: selectedAnswerList,
          argumentName: Constant.clinicalImpressionEventType,
          isFromMoreScreen: true,
        ));
      });
    }
  }
}
