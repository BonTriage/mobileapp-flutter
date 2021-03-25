import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
//import 'package:flutter_share/flutter_share.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';
import 'package:share/share.dart';

class PDFScreen extends StatefulWidget {
  final String base64String;

  const PDFScreen({Key key, @required this.base64String}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String pathPDF = "";
  final pdfViwerRef = new PDFViewerPlugin();
  Rect _rect;
  Timer _resizeTimer;

  Future<File> pdfPath;

  AppBar _appBar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pdfPath = Utils.createFileOfPdfUrl(widget.base64String);
      Utils.createFileOfPdfUrl(widget.base64String).then((value) {
        setState(() {
          pathPDF = value.path;
        });
      });
    });
    pdfViwerRef.close();

    _appBar = AppBar(
      backgroundColor: Constant.chatBubbleGreen,
      title: Text("Generate Report"),
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            shareGenerateReport();
          },
        ),
      ],
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    pdfViwerRef.close();
    pdfViwerRef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: pathPDF.isNotEmpty ? _getWidget() : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: Constant.chatBubbleGreen,
        child: Icon(Icons.share),
        elevation: 10,
      ),
    );
  }

  void shareGenerateReport() async {
    // Future<dynamic> docs = pdfPath;
    // if (docs == null || docs.isEmpty) return null;

    /*await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: pathPDF,
    );*/

    Share.shareFiles(
      [pathPDF]
    );
  }

  Widget _getWidget() {
    if (_rect == null) {
      _rect = _buildRect(context);
      pdfViwerRef.launch(
        pathPDF,
        rect: _rect,
      );
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
          pdfViwerRef.resize(_rect);
        });
      }
    }
    return Container();
  }

  Rect _buildRect(BuildContext context) {
    final fullscreen = _appBar == null;

    final mediaQuery = MediaQuery.of(context);
    final topPadding = true ? mediaQuery.padding.top : 0.0;
    final top =
    fullscreen ? 0.0 : _appBar.preferredSize.height + topPadding;
    var height = mediaQuery.size.height - top;
    if (height < 0.0) {
      height = 0.0;
    }

    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }
}
