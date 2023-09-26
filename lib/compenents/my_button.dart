import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;
  final double width;
  final double height;
  final double fontsize;
  final double padding;

  const MyButton({super.key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.height,
    required this.width,
    required this.fontsize,
    required this.padding
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontsize),),
        ),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyTextButton({super.key, required this.onTap,required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(text,style: const TextStyle(
          color: Colors.blue, fontWeight: FontWeight.bold),),
    );
  }
}
class MyIconButton extends StatelessWidget {
  final Function()? onTap;
  final icon;

  const MyIconButton({super.key, required this.onTap,required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: icon,
    );
  }
}