import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xff0e2731),
              Color(0xff0d3338),
              Color(0xff0d4b46),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
               backgroundColor: Color(0xff0e232f),
        currentIndex: currentIndex,
        selectedItemColor: Color(0xffafd794),
        unselectedItemColor: Color(0xff364f48),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("ME"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            title: Text("RECORDS"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("DISCOVER"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            title: Text("MORE"),
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
