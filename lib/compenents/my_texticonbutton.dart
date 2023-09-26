import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final IconData icon;
  final MainAxisAlignment alignment;
  final Color? textColor;
  final bool leftorright;


  TextIconButton({required this.onTap,required this.text,required this.icon,required this.alignment,required this.textColor,required this.leftorright});

  @override
  Widget build(BuildContext context) {
    if(leftorright){
      return InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Text(text,style: TextStyle(color: textColor),),
            SizedBox(width: 10,),
            Icon(icon),
          ],
        ),
      );
    }else{
      return InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Icon(icon),
            SizedBox(width: 10,),
            Text(text,style: TextStyle(color: textColor),),
          ],
        ),
      );
    }
  }
}
