import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_textfield.dart';
import 'package:haber/screens/hobies_screen.dart';
import 'package:haber/screens/register_screen.dart';
import 'package:haber/screens/reset_password_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  bool obsecure= true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
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
                  Text("Hoşgeldin, lütfen giriş yap.",style: GoogleFonts.aBeeZee(fontSize: 20)),
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
                  MyButton(
                    onTap: () {
                      if(emailController.text.isEmpty || sifreController.text.isEmpty){
                        Get.snackbar("Dikkat", "Tüm alanları eksiksiz doldurun.",
                            snackPosition: SnackPosition.BOTTOM);
                      }
                      else{
                        AuthService().login(emailController.text, sifreController.text, context);
                        Get.back();
                      }
                    },
                    text: "Giriş Yap",
                    color: const Color.fromARGB(100, 100, 100, 100),
                    height: 80,
                    fontsize: 25,
                    padding: 25,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const Divider(color: Colors.white,),
                  SignInButton(
                      Buttons.google,
                      text: "Google ile devam et",
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      onPressed: () async{
                        await AuthService().signinWithGoogle();
                        final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Users").where('mail',isEqualTo: AuthService().firebaseAuth.currentUser?.email).get();
                        if(snapshot.docs.isEmpty){
                          FirebaseFirestore.instance.collection("Users").add(
                              {
                                'uid':AuthService().firebaseAuth.currentUser!.uid,
                                'mail':AuthService().firebaseAuth.currentUser?.email,
                                'date':DateTime.now(),
                                'username':AuthService().firebaseAuth.currentUser?.email!.split('@')[0],
                                'bio': 'Hakkınızda...',
                                'imageUrl':'https://cf.kizlarsoruyor.com/q5913350/0210e882-fab7-4c03-8f21-9b0e6a801cc5.jpg',
                                'name':'   ',
                                'following':[]
                              });
                          Get.to(()=>const HobiesScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                        }else{
                          Get.back();
                        }
                      }
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Hesabın yok mu ? "),
                      MyTextButton(
                        text: "Hemen üye ol",
                        onTap: () {
                          Get.to(()=>const RegisterScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                        },
                      ),
                    ],
                  ),
                  MyTextButton(
                    text: "Şifreni mi unuttun ?",
                    onTap: () {
                      Get.to(()=>ResetPasswordScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
