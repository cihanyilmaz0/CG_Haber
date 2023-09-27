import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_textfield.dart';
import 'package:haber/screens/hobies_screen.dart';
import 'package:get/get.dart';
import 'package:haber/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  TextEditingController sifreonayController = TextEditingController();
  bool obsecure= true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A),Colors.black54,Color(0xFF000000),],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 22,),
                Text("Kayıt Ol",style: GoogleFonts.aBeeZee(fontSize: 20)),
                const SizedBox(height: 22,),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: MyTextField(emailController, "Mail Adres", false,TextInputType.emailAddress,null)),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: MyTextField(sifreController,"Şifre",obsecure,TextInputType.text,
                      MyIconButton(
                        onTap: () {
                          obsecure=!obsecure;
                          setState(() {});
                        },
                        icon: obsecure ? const Icon(Icons.visibility,color: Colors.black,):const Icon(Icons.visibility_off,color: Colors.black),
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: MyTextField(sifreonayController,"Şifre Onay",obsecure,TextInputType.text,
                      MyIconButton(
                        onTap: () {
                          obsecure=!obsecure;
                          setState(() {});
                        },
                        icon: obsecure ? const Icon(Icons.visibility,color: Colors.black):const Icon(Icons.visibility_off,color: Colors.black),
                      ),
                    )
                ),
                RichText(
                  text: const TextSpan(
                    text: '',
                    children: <TextSpan>[
                      TextSpan(
                        text:
                        'Kayıt olarak şu şartlarımızı kabul etmiş olursunuz, ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      TextSpan(
                          text:
                          'Hizmet şartları ve gizlilik politikası',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)
                      ),
                    ],
                  ),
                ),
                MyButton(
                  onTap: () async {
                    if (emailController.text.isEmpty ||
                        sifreController.text.isEmpty ||
                        sifreonayController.text.isEmpty) {
                      Get.snackbar("Dikkat", "Tüm alanları eksiksiz doldurun.",
                          snackPosition: SnackPosition.BOTTOM);
                    } else if (sifreController.text != sifreonayController.text) {
                      Get.snackbar("Dikkat", "Şifreler aynı değil.",
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      User? result = await AuthService().register(
                          emailController.text, sifreController.text, context);
                      final QuerySnapshot snapshot = await FirebaseFirestore
                          .instance.collection("Users").where(
                          'mail', isEqualTo: emailController.text).get();
                      if (snapshot.docs.isEmpty) {
                        FirebaseFirestore.instance.collection("Users").add(
                            {
                              'uid': AuthService().firebaseAuth.currentUser!.uid,
                              'mail': emailController.text,
                              'date': DateTime.now(),
                              'username': emailController.text.split('@')[0],
                              'bio': 'Hakkınızda...',
                              'name':'   ',
                              'imageUrl':'https://cf.kizlarsoruyor.com/q5913350/0210e882-fab7-4c03-8f21-9b0e6a801cc5.jpg',
                              'following':[]
                            }
                        );
                        if (result != null) {
                          emailController.text = "";
                          sifreController.text = "";
                          sifreonayController.text = "";
                        }
                        Get.to(()=>const HobiesScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000));
                      }
                    };
                  },
                  text: "Onayla ve Kayıt Ol",
                  color: const Color.fromARGB(100, 100, 100, 100),
                  height: 80,
                  fontsize: 25,
                  padding: 25,
                  width: MediaQuery.of(context).size.width,
                ),
                const Divider(color: Colors.white,),
                MyTextButton(
                  text: "Hemen giriş yap",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
