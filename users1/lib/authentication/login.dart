import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users1/authentication/auth_screen.dart';
import 'package:users1/global/global.dart';
import 'package:users1/mainScreens/home_screen.dart';
import 'package:users1/widgets/custom_text_field.dart';
import 'package:users1/widgets/error_dialogue.dart';
import 'package:users1/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
{

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      //Login
      loginNow();
    }

    else
    {
      showDialog(
        context: context,
        builder: (c)
        {
          return ErrorDialogue(
            message: "Please Write email/password.",
          );
        }
      );
    }
  }

  loginNow() async
  {
    showDialog(
      context: context, 
      builder: (c)
      {
        return LoadingDialog(
          message: "Checking Credentials",
        );
      }
    );

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (c)
        {
          return ErrorDialogue(
            message: error.message.toString(),
          );
        }
      );
    });
    if(currentUser != null)
    {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("users")
    .doc(currentUser.uid)
    .get()
    .then((snapshot) async {
      if(snapshot.exists){
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", snapshot.data()!["email"]);
        await sharedPreferences!.setString("name", snapshot.data()!["name"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);

        List <String> userBasketList = snapshot.data()!["userBasket"].cast<String>();
        await sharedPreferences!.setStringList("userBasket", userBasketList);

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      }
      else
      {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

        showDialog(
          context: context, 
          builder: (c)
          {
            return ErrorDialogue(
              message: "No Record Found.",
            );
          }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                  "images/login.png",
                  height: 270,
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Sign In",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
            ),
            onPressed: ()=> {  formValidation()
},
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}