import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';

class MeScreenTutorial extends StatefulWidget {
  final GlobalKey logDayGlobalKey;
  final GlobalKey addHeadacheGlobalKey;
  final GlobalKey recordsGlobalKey;

  const MeScreenTutorial({Key key, @required this.logDayGlobalKey, @required this.addHeadacheGlobalKey, @required this.recordsGlobalKey}) : super(key: key);

  @override
  _MeScreenTutorialState createState() => _MeScreenTutorialState();
}

class _MeScreenTutorialState extends State<MeScreenTutorial> {

  @override
  void initState() {
    super.initState();
    RenderBox box = widget.logDayGlobalKey.currentContext.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    print('LogDayOffset????$position???${box.size}');

    RenderBox box1 = widget.addHeadacheGlobalKey.currentContext.findRenderObject();
    Offset position1 = box1.localToGlobal(Offset.zero);
    print('AddHeadacheOffset????$position1');

    /*RenderBox box2 = widget.recordsGlobalKey.currentContext.findRenderObject();
    Offset position2 = box2.localToGlobal(Offset.zero);
    print('RecordsOffset????$position2');*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          ClipPath(
            clipper: TutorialClipper(
              logDayBox: widget.logDayGlobalKey.currentContext.findRenderObject(),
              addHeadacheBox: widget.addHeadacheGlobalKey.currentContext.findRenderObject(),
            ),
            child: Container(
              color: Constant.backgroundColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialClipper extends CustomClipper<Path> {
  final RenderBox logDayBox;
  final RenderBox addHeadacheBox;
  final RenderBox recordsBox;

  const TutorialClipper({this.logDayBox, this.addHeadacheBox, this.recordsBox});

  @override
  Path getClip(Size size) {
    Offset logDayOffset = logDayBox.localToGlobal(Offset.zero);
    Size logDaySize = logDayBox.size;

    Offset addHeadacheOffset = addHeadacheBox.localToGlobal(Offset.zero);
    Size addHeadacheSize = addHeadacheBox.size;
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(logDayOffset.dx, logDayOffset.dy, logDaySize.width, logDaySize.height), Radius.circular(20)))
        ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(addHeadacheOffset.dx, addHeadacheOffset.dy, addHeadacheSize.width, addHeadacheSize.height), Radius.circular(20)))
        ..close(),
    );
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
