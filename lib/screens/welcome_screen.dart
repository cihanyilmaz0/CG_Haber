import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:get/get.dart';
import 'package:haber/main.dart';
import 'package:haber/screens/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.55,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),bottomLeft: Radius.circular(100)),
                  color: Colors.black87,
                ),
              ),
              const Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage("https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/9b698070-cbb3-4aea-9ba0-88cc58549f9d/d8ztacr-6bb975ee-2848-4c25-bd48-e120f95df724.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzliNjk4MDcwLWNiYjMtNGFlYS05YmEwLTg4Y2M1ODU0OWY5ZFwvZDh6dGFjci02YmI5NzVlZS0yODQ4LTRjMjUtYmQ0OC1lMTIwZjk1ZGY3MjQucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.-fFrC5UUKRO78M-SkXVzHjYmIIPUr7v26BNvTrf9Q_s"),
                  radius: 80,
                  backgroundColor: Colors.black,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/1.50),
                    Text("Hoşgeldiniz.",style: GoogleFonts.oswald(fontSize: 30),),
                    const Spacer(),
                    MyButton(
                      text: "Başlayın",
                      onTap: () {
                        Get.to(()=>const LoginScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
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
            ],
          ),
    );
  }
}
