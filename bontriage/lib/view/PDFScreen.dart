import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class PDFScreen extends StatefulWidget {
  final String base64String;

  const PDFScreen({Key key, @required this.base64String}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String pathPDF = "";

  Future<File> pdfPath;

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
    return pathPDF.isNotEmpty
        ? PDFViewerScaffold(
            appBar: AppBar(
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
            ),
            path: pathPDF)
        : Scaffold(
            body: Container(),
          );
  }

  void shareGenerateReport() async {
    // Future<dynamic> docs = pdfPath;
    // if (docs == null || docs.isEmpty) return null;

    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: pdfPath.toString() ,
    );
  }
}
