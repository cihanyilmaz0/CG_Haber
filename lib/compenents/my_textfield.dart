import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obsecure;
  final type;
  final icon;

  MyTextField(this.controller, this.hintText, this.obsecure,this.type,this.icon);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecure,
      keyboardType: type,
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
          suffixIcon: icon,
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}

class MySearchField extends StatelessWidget {
  final TextEditingController _controller;
  var focus;
  final Function(String value) onChan;

  MySearchField(this._controller,this.focus,this.onChan);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _controller,
          focusNode: focus,
          onChanged: onChan,
          decoration: const InputDecoration(
            filled: true,
            hintText: "Ara",
            contentPadding: EdgeInsets.only(top: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
