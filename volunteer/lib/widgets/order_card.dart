
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../mainScreen/order_details_screen.dart';
import '../models/posts.dart';


class OrderCard extends StatelessWidget 
{
  final int? postCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateQuantitiesList;

  OrderCard({
    this.postCount,
    this.data,
    this.orderID,
    this.separateQuantitiesList,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () 
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailsScreen(orderID: orderID)));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black12,
              Colors.white54,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: postCount! * 125,
        child: ListView.builder(
          itemCount: postCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index)
          {
            Posts model = Posts.fromJson(data![index].data()! as Map<String, dynamic>);
            return placedOrderDesignWidget(model, context, separateQuantitiesList![index]);
          },
        ),
      ),
    );
  }
}


Widget placedOrderDesignWidget(Posts model, BuildContext context, separateQuantitiesList)
{
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(model.thumbnailUrl!, width: 120,),
        const SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(
                height: 20,
              ),
              
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.postTitle!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Acme",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,), 
                ],
              ),

              const SizedBox(
                height: 20,
              ),
            
              Row(
                children: [
                  const Text(
                    "X ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      separateQuantitiesList,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: "Acme",
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ],
    ),
  );
}