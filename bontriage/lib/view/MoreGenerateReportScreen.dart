import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/TabNavigatorRoutes.dart';
import 'package:mobile/util/constant.dart';
import 'package:mobile/view/MoreSection.dart';

class MoreGenerateReportScreen extends StatefulWidget {
  final Function(BuildContext, String, dynamic) onPush;
  final Function(String) openActionSheetCallback;

  const MoreGenerateReportScreen({Key key, this.onPush, this.openActionSheetCallback})
      : super(key: key);
  @override
  _MoreGenerateReportScreenState createState() => _MoreGenerateReportScreenState();
}

class _MoreGenerateReportScreenState extends State<MoreGenerateReportScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.onPush);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: Constant.backgroundBoxDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
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
                                  Constant.generateReport,
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
                          padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Constant.moreBackgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MoreSection(
                                text: Constant.dateRange,
                                moreStatus: Constant.last2Weeks,
                                isShowDivider: true,
                              ),
                              MoreSection(
                                text: Constant.dataToInclude,
                                moreStatus: Constant.all,
                                isShowDivider: true,
                              ),
                              MoreSection(
                                text: Constant.fileType,
                                moreStatus: Constant.pdf,
                                isShowDivider: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingWidget(
                          onPressed: () {
                            widget.openActionSheetCallback(Constant.generateReportActionSheet);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.chatBubbleGreen
                            ),
                            child: Text(
                              Constant.generateReport,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Constant.bubbleChatTextView,
                                  fontFamily: Constant.jostMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
