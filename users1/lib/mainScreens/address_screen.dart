import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users1/assistantMethods/address_changer.dart';
import 'package:users1/global/global.dart';
import 'package:users1/mainScreens/save_address_screen.dart';
import 'package:users1/models/address.dart';
import 'package:users1/widgets/address_design.dart';
import 'package:users1/widgets/progress_bar.dart';
import 'package:users1/widgets/simple_app_bar.dart';

class AddressScreen extends StatefulWidget 
{
  final String? donarUID;

  AddressScreen({this.donarUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> 
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "UpAhaar",),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add New Address"),
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.add_location, color: Colors.white),
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=> SaveAddressScreen()));
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Shipment Address : ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          Consumer<AddressChanger>(builder: (context, address, c){
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .snapshots(),
                builder: (context, snapshot)
                {
                  return !snapshot.hasData 
                  ? Center(child: CircularProgress(),) 
                  : snapshot.data!.docs.length == 0 
                  ? Container() 
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index)
                      {
                        return AddressDesign(
                          currentIndex: address.count,
                          value: index,
                          addressID: snapshot.data!.docs[index].id,
                          donarUID: widget.donarUID,
                          model: Address.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>
                          ),
                        );
                      },
                    );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}