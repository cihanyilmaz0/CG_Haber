import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInfo extends StatelessWidget {
  final IconData icon;
  final String data;


  MyInfo(this.icon, this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14,bottom: 10,top: 10),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 15,),
          Expanded(child: Text(data,style: GoogleFonts.oswald(color: Colors.grey,fontSize: 16),))
        ],
      ),
    );
  }
}
