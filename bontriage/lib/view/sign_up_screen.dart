import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff0e232f),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('images/aurora.png'),

                ),
                SizedBox(width: 10,),
                Text(
                  'Aurora',
                  style: TextStyle(
                      color: Color(0xffafd794),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Text(
              'Conquer your headaches',
              style: TextStyle(
                color: Color(0xffafd794),
                fontSize: 15,
                fontFamily: 'FuturaMaxiLight',
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Get a personalized understanding\n of your migraines and headaches\n through tools developed by leading board-certified migraine and headache and specialists.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0x8Cafd794),
                  height: 1.7,
                  fontSize: 14,
                fontFamily: 'FuturaMaxiLight',
              ),
            ),
            SizedBox(height: 100),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xffafd794),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Start Your Free Assessment',
                style: TextStyle(
                  color: Colors.black,
                    fontSize: 11,
                  fontFamily: 'FuturaMaxiLight',
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text.rich(TextSpan(
              children: <TextSpan> [
                TextSpan(text: 'or ', style: TextStyle(color: Color(0xffafd794),)),
                TextSpan(text: 'sign-in', style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xffafd794),
                )),
                TextSpan(text: ' to an existing account.', style: TextStyle(color: Color(0xffafd794),)),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
