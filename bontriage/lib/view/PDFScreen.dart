import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:mobile/util/Utils.dart';

class PDFScreen extends StatefulWidget {
  final String base64String;

  const PDFScreen({Key key, @required this.base64String}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //String base64String = 'JVBERi0xLjQKJeLjz9MKNCAwIG9iago8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDk5MD4+c3RyZWFtCniclVZdr+M0EH3Pr5hHkPaafDfhCS2XFYuoxELRCiEe3GSaeHHsXNtpt/vrGTtJbwVCbdWXGX+Mz5w5M+lL9HYXxVDlCasq2LXRD7voQ/QSxSzONgWcohR+ov1PURLDNvrzrxjaKCuhigt/foiKomZptfpy9bOSxTm5dPTKvJzqo4+RorD+Z7qozFhcQZ4lrMgo5urGLIMyDXZaeztmVb7YTUQPlcniFVWww43VDsHo2OKmbFPCcifLvLOEm50mWl5a9hYI6bWzROyjg4fOijipyzkB4vCbdwkkObEGu0OUhMw8OthUJSMid0P01XvljG6nxgmtvv1698lzfeEghEghSf99nzDndbi/64WFVjfTgMqBHbERB4EWXI/QaOVo1YI+BN/gqI2DDhUa7rCFg9FD2Hmr1c4I3iFsRWe4ULili9oAH0f2iure9IhzqreH91ujR7w/r5hYTV7zkngkpN2STssdB37kQvK9RBAqrBJC4KoFpR1waNHRPqW25Mrteu41xRZxhFYcERZc/wenrGpWzDRza9Faz/HjdJQkqmym49cZ1XNAae/mpSQBJjMvz8gNfK+lRN5N+OZWBnHJ0nIhFOFA9/RJqG6lxyuEqj3z2yNveeMNYan250BrI4USDZcghtEQBSRTIGPk5lo/XNkTGgqjb3Fa1KnvMI/oZULrZU/6VFS6y/O+opOl8PsznPVkYOROeOZhd/UUASCby/OX+SSnZIZxckiilZ02wvXDTTAb6qOZ15akJkmrIdZec9M+NWicbybSFk5GS90RLxZOFBl4e+Sqoa3lUMN9Jl5rP65pbLEVDXVSoBE/j3TQ3gRUFqyeFUehthTHB/iZaq6oap6A624n26te+C5vCQuxv8eFCIkuDAA7STdj863g6DKutxo5tTd7oChSVswK4jD2ZxvEQJPhwon38TMfhJrfob1WGGwciewo8OSnD1dncL7aPomPCCeUBBLDOhnDPKXUTTBZzZJZPM4zYdEcRYNwFBzwaaCeAu4uAb/bk7pDyzNaerxvi7hmdRpe+4UUp0ls8F4dtBn4Q9M6r1JWzhT+cSVnXz4OWf10pvI+adnCwCU+DjMvMpYXy3hp4Z3k3Z2TZUOX05Ils+BW4VroOc3Gpueqo3hWdCoIXDl5Xoep5NbBgWo7EMW9fRx0Vpes3syDyZB675+FWVmzTbJ8OwOY0YPJSVP4t31Ds3XQv5MwMkrDkgQbbXxvhI8HKSwpvR6zhBbOF9wr0P+8lafrfHj290/XEUkIngKaN46ooixDyNDtwn917HQg2kKlqTGXgetCssuz/j/Vh+gfyUaVdwplbmRzdHJlYW0KZW5kb2JqCjEgMCBvYmoKPDwvQ29udGVudHMgNCAwIFIvVHlwZS9QYWdlL1Jlc291cmNlczw8L1Byb2NTZXQgWy9QREYgL1RleHQgL0ltYWdlQiAvSW1hZ2VDIC9JbWFnZUldL0ZvbnQ8PC9GMSAyIDAgUi9GMiAzIDAgUj4+Pj4vUGFyZW50IDUgMCBSL01lZGlhQm94WzAgMCA1OTUuMjggODQxLjg4XT4+CmVuZG9iago3IDAgb2JqCjw8L0Rlc3RbMSAwIFIvWFlaIDAgNzk5Ljg4IDBdL05leHQgOCAwIFIvVGl0bGUoSW50cm9kdWN0aW9uOikvUGFyZW50IDYgMCBSPj4KZW5kb2JqCjggMCBvYmoKPDwvRGVzdFsxIDAgUi9YWVogMCA3NTYuODMgMF0vTmV4dCA5IDAgUi9UaXRsZShTY29wZTopL1BhcmVudCA2IDAgUi9QcmV2IDcgMCBSPj4KZW5kb2JqCjkgMCBvYmoKPDwvRGVzdFsxIDAgUi9YWVogMCA2ODYuOTIgMF0vTmV4dCAxMCAwIFIvVGl0bGUoUmVwb3J0IERldGFpbHM6KS9QYXJlbnQgNiAwIFIvUHJldiA4IDAgUj4+CmVuZG9iagoxMCAwIG9iago8PC9EZXN0WzEgMCBSL1hZWiAwIDUzNi40NyAwXS9OZXh0IDExIDAgUi9UaXRsZShQZXJzb25hbCBJbmZvcm1hdGlvbjopL1BhcmVudCA2IDAgUi9QcmV2IDkgMCBSPj4KZW5kb2JqCjExIDAgb2JqCjw8L0Rlc3RbMSAwIFIvWFlaIDAgNDgwIDBdL05leHQgMTIgMCBSL1RpdGxlKFJlZCBGbGFnczopL1BhcmVudCA2IDAgUi9QcmV2IDEwIDAgUj4+CmVuZG9iagoxMiAwIG9iago8PC9EZXN0WzEgMCBSL1hZWiAwIDQyMy41MiAwXS9UaXRsZShUcmVuZHM6KS9QYXJlbnQgNiAwIFIvUHJldiAxMSAwIFI+PgplbmRvYmoKNiAwIG9iago8PC9UeXBlL091dGxpbmVzL0NvdW50IDYvRmlyc3QgNyAwIFIvTGFzdCAxMiAwIFI+PgplbmRvYmoKMiAwIG9iago8PC9TdWJ0eXBlL1R5cGUxL1R5cGUvRm9udC9CYXNlRm9udC9UaW1lcy1Cb2xkL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZz4+CmVuZG9iagozIDAgb2JqCjw8L1N1YnR5cGUvVHlwZTEvVHlwZS9Gb250L0Jhc2VGb250L1RpbWVzLVJvbWFuL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZz4+CmVuZG9iago1IDAgb2JqCjw8L0tpZHNbMSAwIFJdL1R5cGUvUGFnZXMvQ291bnQgMS9JVFhUKDIuMS43KT4+CmVuZG9iagoxMyAwIG9iago8PC9QYWdlTW9kZS9Vc2VPdXRsaW5lcy9UeXBlL0NhdGFsb2cvT3V0bGluZXMgNiAwIFIvUGFnZXMgNSAwIFI+PgplbmRvYmoKMTQgMCBvYmoKPDwvTW9kRGF0ZShEOjIwMjEwMzIzMTEyNDA2WikvQ3JlYXRpb25EYXRlKEQ6MjAyMTAzMjMxMTI0MDZaKS9Qcm9kdWNlcihpVGV4dCAyLjEuNyBieSAxVDNYVCk+PgplbmRvYmoKeHJlZgowIDE1CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMTA3MiAwMDAwMCBuIAowMDAwMDAxOTA1IDAwMDAwIG4gCjAwMDAwMDE5OTQgMDAwMDAgbiAKMDAwMDAwMDAxNSAwMDAwMCBuIAowMDAwMDAyMDg0IDAwMDAwIG4gCjAwMDAwMDE4MzkgMDAwMDAgbiAKMDAwMDAwMTI0NCAwMDAwMCBuIAowMDAwMDAxMzM2IDAwMDAwIG4gCjAwMDAwMDE0MzIgMDAwMDAgbiAKMDAwMDAwMTUzOCAwMDAwMCBuIAowMDAwMDAxNjUxIDAwMDAwIG4gCjAwMDAwMDE3NTEgMDAwMDAgbiAKMDAwMDAwMjE0NyAwMDAwMCBuIAowMDAwMDAyMjI5IDAwMDAwIG4gCnRyYWlsZXIKPDwvSW5mbyAxNCAwIFIvSUQgWzw0OGRmNGMzNjNiYzhjM2M4ZGZmNWMwZWQ4ZmNjY2U1Zj48NmZkMzcwZDM3NmRiNThjMDgxOTUzNzA3MTgzNjA0ZGE+XS9Sb290IDEzIDAgUi9TaXplIDE1Pj4Kc3RhcnR4cmVmCjIzNDAKJSVFT0YK';
      Utils.createFileOfPdfUrl(widget.base64String).then((value) {
        setState(() {
          pathPDF = value.path;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return pathPDF.isNotEmpty ? PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF) : Scaffold(
      body: Container(),
    );
  }
}
