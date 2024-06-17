import 'package:flutter/material.dart';

ButtonStyle btnStyle = ElevatedButton.styleFrom(
    maximumSize: Size(300, 50),
    backgroundColor: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),side: BorderSide(width: 2, color: Colors.black)));
TextStyle btnTextStyle = TextStyle(color: Colors.white, fontSize: 17,fontWeight: FontWeight.bold);
TextStyle appBarTextStyle = TextStyle(color: Colors.white);
