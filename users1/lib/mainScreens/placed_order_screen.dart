import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users1/assistantMethods/assistant_methods.dart';
import 'package:users1/global/global.dart';
import 'package:users1/mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget 
{
  
  String? addressID;
  String? donarUID;

  PlacedOrderScreen({this.donarUID, this.addressID});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> 
{

  String orderID = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userBasket"),
      "paymentDetails": "Donation",
      "orderTime": orderID,
      "isSuccess": true,
      "donarUID": widget.donarUID,
      "riderUID": "",
      "status": "normal",
      "orderID": orderID,
    });

    writeOrderDetailsForDonar({
      "addressID": widget.addressID,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userBasket"),
      "paymentDetails": "Donation",
      "orderTime": orderID,
      "isSuccess": true,
      "donarUID": widget.donarUID,
      "riderUID": "",
      "status": "normal",
      "orderID": orderID,
    }).whenComplete(() {
      clearBasketNow(context);
      setState(() {
        orderID = "";
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
        Fluttertoast.showToast(msg: "Congratulations, Order has been placed Successfully !!!");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
    .collection("users")
    .doc(sharedPreferences!.getString("uid"))
    .collection("orders")
    .doc(orderID)
    .set(data);
  }

  Future writeOrderDetailsForDonar(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
    .collection("orders")
    .doc(orderID)
    .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset("images/delivery.jpg"),

            const SizedBox(height: 12,),

            ElevatedButton(
              child: const Text("Place Order"),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
              ),
              onPressed: () 
              {
                addOrderDetails();
              },
            ),

          ],
        ),
      ),
    );
  }
}