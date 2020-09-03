import 'package:flutter/material.dart';
import 'package:mobile/util/constant.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2000),(){Navigator.pushReplacementNamed(context,Constant.loginRouter);});
    return Scaffold(
      body: Center(child: Text('BonTriage' ,style: TextStyle(
          color:Color(0xffafd794),
        fontSize: 16,
      ),)),

      backgroundColor: Color(0xff0e232f),

    );
  }
}
