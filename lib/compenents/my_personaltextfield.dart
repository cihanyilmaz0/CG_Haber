import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyProfileField extends StatelessWidget {
  final controller;
  final String hintText;
  final String labelText;

  MyProfileField(this.controller, this.hintText,this.labelText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/14,
      width: MediaQuery.of(context).size.width*0.94,
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        style: TextStyle(
            color: Colors.black,
            fontSize: 14
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black,fontSize: 16),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
