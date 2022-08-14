import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteer/maps/map_util.dart';
import 'package:volunteer/splashScreen/splash_screen.dart';

import '../assistantMethods/get_current_location.dart';
import '../global/global.dart';

class ParcelDeliveringScreen extends StatefulWidget {

  

  String? receiverId;
  String? receiverAddress;
  String? receiverLat;
  String? receiverLng;
  String? donarId;
  String? getOrderId;

  ParcelDeliveringScreen({
    this.receiverId,
    this.receiverAddress,
    this.receiverLat,
    this.receiverLng,
    this.donarId,
    this.getOrderId,
  });

  

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {

  String orderTotalAmount = "";

  confirmParcelHasBeenDelivered(getOrderId, donarId, receiverId,  receiverAddress, receiverLat, receiverLng)
  {
    String volunteerNewTotalCredit = ((double.parse(previousVolunteerCredits)) + (double.parse(perParcelDeliveryCredit))).toString();
      
    FirebaseFirestore.instance
    .collection("orders")
    .doc(getOrderId)
    .update({
    "status" : "delivering",
    "address" : completeAddress,
    "lat":position!.latitude,
    "lng" : position!.longitude,
    "credits" : perParcelDeliveryCredit,
    }).then((value){
      FirebaseFirestore.instance
      .collection("volunteers")
      .doc(sharedPreferences!.getString("uid"))
      .update(
      {
        "credits" : volunteerNewTotalCredit,
      });
    }).then((value) 
    {
      FirebaseFirestore.instance
      .collection("donars")
      .doc(widget.donarId)
      .update({
        "credits" :(double.parse(orderTotalAmount) + (double.parse(previousCredits))).toString(),
      });
    }).then((value)
    {
      FirebaseFirestore.instance
      .collection("receivers")
      .doc(receiverId)
      .collection("orders")
      .doc(getOrderId)
      .update(
        {
          "status": "ended",
          "volunteerUID": sharedPreferences!.getString("uid")
        });
    });

    Navigator.push(context, MaterialPageRoute(builder: (c) =>  MySplashScreen()));
  }
  
  getOrderTotalAmount()
  {
    FirebaseFirestore.instance
    .collection("orders")
    .doc(widget.getOrderId)
    .get()
    .then((snap)
    {
      orderTotalAmount =  snap.data()!["totalCredit"].toString();
      widget.donarId = snap.data()!["donarUID"].toString();
    }).then((snap)
    {
      getDonarData();
    });
  }

  getDonarData()
  {
    FirebaseFirestore.instance
    .collection("donars")
    .doc(widget.donarId)
    .get()
    .then((snap)
    {
      previousCredits = snap.data()!["credits"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();

    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm2.png",
           ),
          const SizedBox(height: 5,),
         
          GestureDetector(
            onTap: ()
            {
                MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, widget.receiverLat, widget.receiverLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset( 
                  "images/restaurant.png",
                  width: 50,
                ),
                
                const SizedBox(width: 7,),
                
                Column(
                  children: const [
                     SizedBox(height: 12,),
          
                      Text(
                      "Show Delivery Drop-off Locations",
                      style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
          
              ],
            ),
          ),

          const SizedBox(width: 40,),


           Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () 
              {
                UserLocation uLocation = UserLocation();
                uLocation.getCurrentLocation();

                confirmParcelHasBeenDelivered(
                  widget.getOrderId, 
                  widget.donarId, 
                  widget.receiverId, 
                  widget.receiverAddress, 
                  widget.receiverLat, 
                  widget.receiverLng
                  );
              },
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
                width: MediaQuery.of(context).size.width - 90,
                height: 50,
                child: const Center(
                  child: Text(
                    "Order has been delivered - Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),


        ],
      ),
    );
  }
}