import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users1/assistantMethods/basket_post_counter.dart';
import 'package:users1/global/global.dart';
import 'package:users1/splashScreen/splash_screen.dart';

separateOrderPostIDs(orderIDs)
{
  List<String> separatePostIDsList = [], defaultPostList = [];
  int i=0;
  
  defaultPostList = List<String>.from(orderIDs);

  for(i; i<defaultPostList.length; i++)
  {
    String post = defaultPostList[i].toString();
    var pos = post.lastIndexOf(":");
    String getPostID = (pos != -1) ? post.substring(0, pos) : post;

    print("\nThis is postID now =" + getPostID);

    separatePostIDsList.add(getPostID);
  }

  print("\nThis is Posts List now =");
  print(separatePostIDsList);

  return separatePostIDsList;

}


separatePostIDs()
{
  List<String> separatePostIDsList = [], defaultPostList = [];
  int i=0;
  
  defaultPostList = sharedPreferences!.getStringList("userBasket")!;

  for(i; i<defaultPostList.length; i++)
  {
    String post = defaultPostList[i].toString();
    var pos = post.lastIndexOf(":");
    String getPostID = (pos != -1) ? post.substring(0, pos) : post;

    print("\nThis is postID now =" + getPostID);

    separatePostIDsList.add(getPostID);
  }

  print("\nThis is Posts List now =");
  print(separatePostIDsList);

  return separatePostIDsList;

}


addPostToBasket(String? foodPostID, BuildContext context,  int postCounter)
{

  List<String>? tempList = sharedPreferences!.getStringList("userBasket");
  tempList!.add(foodPostID! + ":$postCounter");

  FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid).update({
    "userBasket": tempList,
  }).then((value) {

    Fluttertoast.showToast(msg: "Item Added Successfully!!!");

    sharedPreferences!.setStringList("userBasket", tempList);

    //Update the Badge
    Provider.of<BasketPostCounter>(context, listen: false).displayBasketListPostsNumber();

  });
}


separateOrderPostQuantities(orderIDs)
{
  List<String> separatePostQuantityList = []; 
  List<String> defaultPostList = [];
  int i=1;
  
  defaultPostList = List<String>.from(orderIDs);

  for(i; i<defaultPostList.length; i++)
  {
    String post = defaultPostList[i].toString();
    
    List<String> listPostCharacters = post.split(":").toList();
    var quanNumber = int.parse(listPostCharacters[1].toString());

    print("\nThis is Quantity Number = " + quanNumber.toString());

    separatePostQuantityList.add(quanNumber.toString());
  }

  print("\nThis is Quantity List now =");
  print(separatePostQuantityList);

  return separatePostQuantityList;

}


separatePostQuantities()
{
  List<int> separatePostQuantityList = []; 
  List<String> defaultPostList = [];
  int i=1;
  
  defaultPostList = sharedPreferences!.getStringList("userBasket")!;

  for(i; i<defaultPostList.length; i++)
  {
    String post = defaultPostList[i].toString();
    
    List<String> listPostCharacters = post.split(":").toList();
    var quanNumber = int.parse(listPostCharacters[1].toString());

    print("\nThis is Quantity Number = " + quanNumber.toString());

    separatePostQuantityList.add(quanNumber);
  }

  print("\nThis is Quantity List now =");
  print(separatePostQuantityList);

  return separatePostQuantityList;

}

clearBasketNow(context)
{
  sharedPreferences!.setStringList("userBasket", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userBasket");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userBasket": emptyList}).then((value)
      {
        sharedPreferences!.setStringList("userBasket", emptyList!);
        Provider.of<BasketPostCounter>(context, listen: false).displayBasketListPostsNumber();
      });
}