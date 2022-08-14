import 'dart:async';

import 'package:flutter/material.dart';
import 'package:volunteer/authentication/auth_screen.dart';
import 'package:volunteer/global/global.dart';

import '../mainScreen/homeScreen.dart';

class MySplashScreen extends StatefulWidget {

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen> {

 startTimer()
 {
   Timer(const Duration(seconds: 2) ,() async
   {
    if(firebaseAuth.currentUser != null)
   {
    Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));  
   }
   else
   {
     Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));  
   }
   });
 }

 @override
  void initState() {
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),

              const SizedBox(height: 10,),
              
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "UpAhaar Volunteer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color : Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}