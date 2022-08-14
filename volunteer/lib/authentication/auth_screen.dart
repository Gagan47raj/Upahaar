import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register.dart';

import 'login.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({ Key? key }) : super(key: key);

  @override
    Widget build(BuildContext context) {

    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue 
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit an App?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
               //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () {
                 Navigator.of(context).pop(true);
                 SystemNavigator.pop();
              }, 
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(246, 223, 170, 139),
                    Color.fromARGB(255, 184, 119, 173),
                  ],
                  begin :  FractionalOffset(0.0, 0.0),
                  end :  FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp, 
                ),
              ),
            ),
            title: const Text(
              "UpAhaar",
              style: TextStyle(
                fontSize: 60,
                color : Colors.white,
                fontFamily: "Signatra",
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock, color: Colors.white,),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(Icons.person, color: Colors.white,),
                  text: "Register",
                ),
              ],
              indicatorColor: Color.fromARGB(96, 213, 104, 235),
              indicatorWeight: 6,
            ),
          ),
          body: Container(
            decoration : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end : Alignment.bottomLeft,
                colors: [
                   Color.fromARGB(246, 223, 170, 139),
                   Color.fromARGB(255, 184, 119, 173),
                ],
              ),
            ),
            child: const TabBarView(
              children: [
                LoginScreen(),
                SignUpScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}