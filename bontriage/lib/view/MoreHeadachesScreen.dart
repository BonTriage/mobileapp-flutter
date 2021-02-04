import 'package:flutter/material.dart';
import 'package:mobile/models/MoreHeadacheScreenArgumentModel.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreHeadachesScreen extends StatefulWidget {
  final Function(BuildContext, String) onPush;
  final Function(String,dynamic) openActionSheetCallback;
  final MoreHeadacheScreenArgumentModel moreHeadacheScreenArgumentModel;


  const MoreHeadachesScreen(
      {Key key, this.onPush, this.openActionSheetCallback, this.moreHeadacheScreenArgumentModel})
      : super(key: key);

  @override
  _MoreHeadachesScreenState createState() => _MoreHeadachesScreenState();
}

class _MoreHeadachesScreenState extends State<MoreHeadachesScreen> {
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
                        Row(
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
                        Divider(
                          thickness: 0.5,
                          height: 30,
                          color: Constant.locationServiceGreen,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.openActionSheetCallback(Constant.deleteHeadacheTypeActionSheet,null);
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
}
