import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home.dart';
class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(

      seconds: 4,
      navigateAfterSeconds: Home(),
      // title: Text("Agri Doctor",
      //     style:TextStyle(
      //         fontSize: 29,
      //         color: Colors.green
      //     )
      // ),
      image:new Image.asset('assets/agri.png'),
      photoSize: 200.0,

      
    );
  }
}
