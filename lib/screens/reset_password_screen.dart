import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("Şifreni mi unuttun ?",style: GoogleFonts.akayaKanadaka(fontSize: MediaQuery.of(context).size.width/12)),
               SizedBox(height: 20,),
               Text("Mail adresini gir sana bir doğrulama kodu gönderelim."),
               Padding(
                 padding: EdgeInsets.all(12),
                   child: MyTextField(controller, "Mail Adresin", false, TextInputType.emailAddress, Icon(Icons.mail,color: Colors.black,))),
               MyButton(
                 text: "Onayla",
                 onTap: () async{
                   try {
                     await FirebaseAuth.instance.sendPasswordResetEmail(email: controller.text);
                     Get.snackbar("Şifreni değiştirmek için sana bir link yolladık.", "Gereksiz postaları kontrol etmeyi unutma.",snackPosition: SnackPosition.BOTTOM);
                   } on FirebaseAuthException catch (e) {
                     Get.snackbar(e.message.toString(),"",snackPosition: SnackPosition.BOTTOM);
                   }
                 },
                 color: Color.fromARGB(100, 100, 100, 100),
                 height: 80,
                 fontsize: 25,
                 padding: 25,
                 width: MediaQuery.of(context).size.width,
               ),
             ],
           ),
         ),
      ),
    );
  }
}
