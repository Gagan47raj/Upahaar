import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:users1/assistantMethods/assistant_methods.dart';
import 'package:users1/models/posts.dart';
import 'package:users1/widgets/app_bar.dart';

class PostDetailScreen extends StatefulWidget {
  
  final Posts? model;

  PostDetailScreen({this.model});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}



class _PostDetailScreenState extends State<PostDetailScreen> 
{
  TextEditingController counterTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(donarUID: widget.model!.donarUID),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: NumberInputPrefabbed.roundedButtons(
              controller: counterTextEditingController,
              incDecBgColor: Colors.amber,
              min: 1,
              max: 9,
              initialValue: 1,
              buttonArrangement: ButtonArrangement.incRightDecLeft,
              
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.postTitle.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.postInfo.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              
            ),
          ),

          const SizedBox(height: 10,),

          Center(
            child: InkWell(
              onTap: ()
              {

                int postCounter = int.parse(counterTextEditingController.text);
                
                List<String> separatePostIDsList = separatePostIDs();
                
                //check if item in cart
                separatePostIDsList.contains(widget.model!.postID) 
                  ? Fluttertoast.showToast(msg: "Item is already in Basket!!")
                  : 
                
                //add to basket
                  addPostToBasket(widget.model!.postID, context, postCounter);

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
                width: MediaQuery.of(context).size.width - 13,
                height: 50,
                child: const Center(
                  child: Text(
                    "Add to Basket",
                    style: TextStyle(color: Colors.white, fontSize: 15),
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