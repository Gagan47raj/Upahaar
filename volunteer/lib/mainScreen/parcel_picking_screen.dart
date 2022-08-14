
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteer/assistantMethods/get_current_location.dart';
import 'package:volunteer/global/global.dart';
import 'package:volunteer/mainScreen/parcel_delivering_screen.dart';
import 'package:volunteer/maps/map_util.dart';

class ParcelPickingScreen extends StatefulWidget { 

  String? receiverId;
  String? donarId;
  String? getOrderID;
  String? receiverAddress;
  double? receiverLat;
  double? receiverLng;

  ParcelPickingScreen(
    {
      this.receiverId,
      this.donarId,
      this.getOrderID,
      this.receiverAddress,
      this.receiverLat,
      this.receiverLng,
    }
  );

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreen();
}

class _ParcelPickingScreen extends State<ParcelPickingScreen> {

  double? donarLat, donarLng;


  getDonarData() async
  {
    FirebaseFirestore.instance
    .collection("donars")
    .doc(widget.donarId)
    .get()
    .then((DocumentSnapshot)
    {
      donarLat =  DocumentSnapshot.data()!["lat"];
      donarLng =  DocumentSnapshot.data()!["lng"];
    });
  }

  @override
  void initState()
  {
    super.initState();
    getDonarData();
  }

  confirmParcelHasBeenPicked(getOrderId, donarId, receiverId,  receiverAddress, receiverLat, receiverLng)
  {
    FirebaseFirestore.instance
    .collection("orders")
    .doc(getOrderId)
    .update({
    "status" : "delivering",
    "address" : completeAddress,
    "lat":position!.latitude,
    "lng" : position!.longitude
    });

    Navigator.push(context, MaterialPageRoute(builder: (c) => ParcelDeliveringScreen(
      receiverId : receiverId,
      receiverAddress : receiverAddress,
      receiverLat : receiverLat,
      receiverLng : receiverLng,
      donarId : donarId,
      getOrderId : getOrderId,
    )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm1.png",
            width: 350,
          ),
          const SizedBox(height: 5,),
         
          GestureDetector(
            onTap: ()
            {
                MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, donarLat, donarLng);
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
                      "Show Donar's Location",
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

                confirmParcelHasBeenPicked(
                  widget.getOrderID, 
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
                    "Order has been picked - Confirmed",
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