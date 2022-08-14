import 'package:flutter/material.dart';
import 'package:users1/models/posts.dart';

class BasketPostDesign extends StatefulWidget 
{
  final Posts? model;
  BuildContext? context;
  final int? quanNumber;

  BasketPostDesign({
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  State<BasketPostDesign> createState() => _BasketPostDesignState();
}

class _BasketPostDesignState extends State<BasketPostDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(widget.model!.thumbnailUrl!, width: 140, height: 120,),
              const SizedBox(width: 6,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.postTitle!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Kiwi",
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: [

                      const Text(
                        "X ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Acme",
                        ),
                      ),

                      Text(
                        widget.quanNumber.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Acme",
                        ),
                      ),
                    ],
                  ),                  
                ],
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}