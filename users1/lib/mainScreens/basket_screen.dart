import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users1/assistantMethods/assistant_methods.dart';
import 'package:users1/assistantMethods/basket_post_counter.dart';
import 'package:users1/mainScreens/address_screen.dart';
import 'package:users1/mainScreens/home_screen.dart';
import 'package:users1/models/posts.dart';
import 'package:users1/splashScreen/splash_screen.dart';
import 'package:users1/widgets/app_bar.dart';
import 'package:users1/widgets/basket_post_design.dart';
import 'package:users1/widgets/progress_bar.dart';
import 'package:users1/widgets/text_widget_header.dart';

class BasketScreen extends StatefulWidget 
{

  final String? donarUID;

  BasketScreen({this.donarUID});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}



class _BasketScreenState extends State<BasketScreen> 
{
  List<int>? separatePostQuantityList;

  @override
  void initState() {
    super.initState();

    separatePostQuantityList = separatePostQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: ()
          {
            clearBasketNow(context);
          },
        ),
        title: const Text(
          "UpAhaar",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_basket, color: Colors.white,),
                onPressed: ()
                {
                  print("Clicked !!!");
                },
              ),

              Positioned(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Center(
                        child: Consumer<BasketPostCounter>(
                          builder: (context, counter, c)
                          {
                            return Text(
                              counter.count.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text(" Clear Basket ", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                clearBasketNow(context);
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared !!!");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text(" Check Out ", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (c)=> AddressScreen(
                      donarUID: widget.donarUID,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [

          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: "My Basket List"),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("posts")
              .where("postID", whereIn: separatePostIDs())
              .orderBy("publishedDate", descending: false)
              .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData 
                  ? SliverToBoxAdapter(child: Center(child: CircularProgress(),),)
                  : snapshot.data!.docs.length == 0 
                  ? //startBuildingBasket() 
                    Container()
                  : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index)
                    {
                      Posts model = Posts.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                      );

                      return BasketPostDesign(
                        model: model,
                        context: context,
                        quanNumber: separatePostQuantityList![index],
                      );
                    },
                    childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}