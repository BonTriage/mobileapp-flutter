import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
  Future<File> pdfPath;

  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Constant.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Constant.chatBubbleGreen,
                    ),
                  ),
                  Text(
                    Constant.generateReport,
                    style: TextStyle(
                      color: Constant.chatBubbleGreen,
                      fontFamily: Constant.jostRegular,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      shareGenerateReport();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Icon(
                      Icons.share,
                      color: Constant.chatBubbleGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: pathPDF.isNotEmpty ? _getWidget() : Container(),
          ),
        ],
      ),
    );
  }

  void shareGenerateReport() async {
    Share.shareFiles(
      [pathPDF]
    );
  }

  Widget _getWidget() {
    return PDFView(
      filePath: pathPDF,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      onRender: (_pages) {

      },
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onViewCreated: (PDFViewController pdfViewController) {
        _controller.complete(pdfViewController);
      },
      onPageChanged: (int page, int total) {
        print('page change: $page/$total');
      },
    );
  }
}
