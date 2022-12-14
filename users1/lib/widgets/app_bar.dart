import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users1/assistantMethods/basket_post_counter.dart';
import 'package:users1/mainScreens/basket_screen.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String? donarUID;


  MyAppBar({this.bottom, this.donarUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              tileMode: TileMode.clamp,
            )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "UpAhaar",
          style: const TextStyle(fontSize: 45, fontFamily: "Signatra"),
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
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> BasketScreen(donarUID: widget.donarUID)));
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
        
      );
  }
}