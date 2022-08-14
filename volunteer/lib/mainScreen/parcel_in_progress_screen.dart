import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistantMethods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';


class ParcelInProgressScreen extends StatefulWidget 
{

  @override
  State<ParcelInProgressScreen> createState() => _ParcelInProgressScreen();
}


class _ParcelInProgressScreen extends State<ParcelInProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "Parcel In Progress",),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection("orders")
            .where("volunteerUID", isEqualTo: sharedPreferences!.getString("uid"))
            .where("status", isEqualTo: "normal")
            .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData 
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index)
                  {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("postID", whereIn: separateOrderPostIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]))
                        .orderBy("publishedDate", descending: true)
                        .get(),
                      builder: (c, snap)
                      {
                        return snap.hasData 
                          ? OrderCard(
                              postCount: snap.data!.docs.length,
                              data: snap.data!.docs,
                              orderID: snapshot.data!.docs[index].id,
                              separateQuantitiesList: separateOrderPostQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                            ) 
                          : Center(child: CircularProgress(),);
                      },
                    );
                  },
                ) 
              : Center(child: CircularProgress(),);
          },
        ),
      ),
    );
  }
}