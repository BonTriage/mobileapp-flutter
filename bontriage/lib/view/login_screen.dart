import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff0e232f),
      body: Container(
        padding: const EdgeInsets.all(15),
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
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: 60,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(fontSize: 15),
                    cursorColor: Color(0xff0E4C47),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      hintText: 'Username',
                      hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                      filled: true,
                      fillColor: Color(0xffcad7bf),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextField(
                    style: TextStyle(fontSize: 15),
                    cursorColor: Color(0xff0E4C47),
                    textAlign: TextAlign.start,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                      filled: true,
                      fillColor: Color(0xffcad7bf),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                decoration: BoxDecoration(
                  color: Color(0xffafd794),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xffafd794),
                fontSize: 16,
                decoration: TextDecoration.underline
              ),
            )
          ],
        ),
      ),
    );
  }
}
