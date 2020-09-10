import 'package:flutter/material.dart';

class DragabbleScrollableSheetDemo extends StatefulWidget {
  @override
  _DragabbleScrollableSheetDemoState createState() =>
      _DragabbleScrollableSheetDemoState();
}

class _DragabbleScrollableSheetDemoState
    extends State<DragabbleScrollableSheetDemo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DraggableScrollableSheet'),
        ),
        body: Container(
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (BuildContext context, myscrollController) {
              return Container(
                color: Colors.tealAccent[200],
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Wrap(
                        runSpacing: -15,
                        children: <Widget>[
                          Center(
                              child: Container(
                                  height: 5,
                                  width: 50,
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5)))),
                          for (var i = 0; i < 30; i++)
                            ListTile(
                              title: Text('item $i'),
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
