import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
    
    final TextEditingController? controller;
    final IconData? data;
    final String? hintText;
    bool? isObsecure = true;
    bool? enable = true;

    CustomTextField(
      {
        this.controller,
        this.data,
        this.hintText,
        this.isObsecure,
        this.enable,
      }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
   	width: 320,
	  padding: EdgeInsets.all(10.0),
	  child: TextField(
     enabled: enable,
     controller: controller,
     obscureText: isObsecure!,
	  autocorrect: true,
	  decoration: InputDecoration(
	  hintText: hintText,
    prefixIcon : Icon(
            data,
            color : Colors.cyan,
          ),
	  hintStyle: TextStyle(color: Colors.grey),
	  filled: true,
	  fillColor: Colors.white70,
	  enabledBorder: OutlineInputBorder(
		borderRadius: BorderRadius.all(Radius.circular(12.0)),
		borderSide: BorderSide(color: Colors.green, width: 2),
	   ),
	  focusedBorder: OutlineInputBorder(
		borderRadius: BorderRadius.all(Radius.circular(10.0)),
		borderSide: BorderSide(color: Colors.green, width: 2),
	  ),
	),
  )
  );
  }
}

