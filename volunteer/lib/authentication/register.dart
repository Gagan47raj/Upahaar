import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunteer/authentication/auth_screen.dart';
import 'package:volunteer/widgets/custon_text_field.dart';
import 'package:volunteer/widgets/error_dialog_box.dart';
import 'package:volunteer/widgets/loading_dialog.dart';

import '../global/global.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 TextEditingController nameController = TextEditingController();
 TextEditingController emailController = TextEditingController();
 TextEditingController passwordController = TextEditingController();
 TextEditingController confirmPasswordController = TextEditingController();
 TextEditingController phoneController = TextEditingController();
 TextEditingController locationController = TextEditingController();

 XFile? imageXFile;
 final ImagePicker _picker = ImagePicker();

 Position? position;
 List<Placemark>? placeMarks;

 String volunteerImageUrl = "";
 String completeAddress = "";


 Future<void> _getImageFromGallery(BuildContext context) async
 {
   imageXFile = await _picker.pickImage(source: ImageSource.gallery);

   setState(() {
     imageXFile;
   });
   Navigator.pop(context);
 }

 
 Future<void> _getImageFromCamera(BuildContext context) async
 {
   imageXFile = await _picker.pickImage(source: ImageSource.camera);

   setState(() {
     imageXFile;
   });
   Navigator.pop(context);
 }

Future<void>_showChoiceDialog(BuildContext context)
{
  return showDialog(context: context,builder: (BuildContext context){

    return AlertDialog(
      title: Text("Choose option",style: TextStyle(color: Colors.blue),),
      content: SingleChildScrollView(
      child: ListBody(
        children: [
          Divider(height: 1,color: Colors.blue,),
          ListTile(
            onTap: (){
              _getImageFromGallery(context);
            },
          title: Text("Gallery"),
            leading: Icon(Icons.account_box,color: Colors.blue,),
      ),

          Divider(height: 1,color: Colors.blue,),
          ListTile(
            onTap: (){
              _getImageFromCamera(context);
            },
            title: Text("Camera"),
            leading: Icon(Icons.camera,color: Colors.blue,),
          ),
        ],
      ),
    ),);
  });
}

Future<void> getCurrentLocation() async
 {
   bool serviceEnabled;
   LocationPermission permission;

   serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
     }

    permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

   Position newPosition = await Geolocator.getCurrentPosition(
     forceAndroidLocationManager: true,
     desiredAccuracy: LocationAccuracy.high,
   );

   position = newPosition;

     placeMarks = await placemarkFromCoordinates(
     position!.latitude,
     position!.longitude,
   );
   
   Placemark pMark = placeMarks![0];

   String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}'; 
   locationController.text = completeAddress;
   } 
   
Future<void> formValidation() async
{
  // if(imageXFile == null)
  // {
  //   showDialog(
  //     context: context, 
  //     builder: (c)
  //     {
  //       return ErrorDialog(
  //         message: "Please select an image !!",
  //       );
  //     }
  //     );
  // }
  //else
  //{
    if(passwordController.text == confirmPasswordController.text)
    {

      if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty)
      {
        showDialog(
          context: context,
          builder: (c)
          {
            return LoadingDialog(
              message: "Registering Account",
            );
          }
        );
        
        String fileName = DateTime.now().millisecondsSinceEpoch.toString(); 
        fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("Volunteer").child(fileName);
        fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot takeSnapshot = await uploadTask.whenComplete(() => {});
        await takeSnapshot.ref.getDownloadURL().then((url)
        {
          volunteerImageUrl = url;

          authenticateSellerAndSignup();
        });
      }
      else
      {
        showDialog(
        context: context, 
        builder: (c)
        {
          return ErrorDialog(
            message: "Please fill the all mandatory field for registration !!",
          );
        }
        );
      }

    }
    else
    {
      showDialog(
        context: context, 
        builder: (c)
        {
          return ErrorDialog(
            message: "Password do no match !!",
          );
        }
        );
    }
  //}
}

Future saveDataToFirestore(User currentUser) async
{
  FirebaseFirestore.instance.collection("volunteer").doc(currentUser.uid).set({
    "volunteerUID" : currentUser.uid,
    "volunteerEmail" : currentUser.email,
    "volunteerName" : nameController.text.trim(),
    "volunteerAvatarUrl" : volunteerImageUrl,
    "phone" : phoneController.text.trim(),
    "address" : completeAddress,
    "status" : "approved",
    "credit" : 0.0,
    "lat" : position!.latitude,
    "lng" : position!.longitude,
  });

  sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences!.setString("uid", currentUser.uid);
  await sharedPreferences!.setString("email", currentUser.email.toString());
  await sharedPreferences!.setString("name", nameController.text.trim());
  await sharedPreferences!.setString("uid", volunteerImageUrl);
}

void authenticateSellerAndSignup() async
{
  User? currentUser;
  

  await firebaseAuth.createUserWithEmailAndPassword(
    email: emailController.text.trim(), 
    password: passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (c)
        {
          return ErrorDialog(
            message: error.message.toString(),
          );
        }
        );
    });

    if(currentUser != null)
    {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => const AuthScreen());
        Navigator.pushReplacement(context, newRoute); 
      });
    }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height:10),
            InkWell(
              onTap: ()
              {
                _showChoiceDialog(context);
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile == null 
                ? 
                Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width*0.20,
                  color: Colors.grey,
                ) : null,
              ),
            ),
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data : Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data : Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data : Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data : Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data : Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data : Icons.my_location,
                    controller: locationController,
                    hintText: "Location",
                    isObsecure: false,
                    enable: true,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label : const Text(
                      "Get my current location",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    onPressed: ()
                      {
                        getCurrentLocation();
                      },             
                    style: ElevatedButton.styleFrom( 
                      primary: Colors.amber,
                      shape:  RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30),
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              child: const Text(
                "Sign Up",
                style : TextStyle(color : Colors.white,fontWeight: FontWeight.bold,),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
              ),
              onPressed: ()
              {
                formValidation();
              } ,
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}