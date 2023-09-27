import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber/models/home_page.dart';
import 'package:haber/screens/loading_screen.dart';
import 'package:haber/screens/login_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:haber/services/home_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<HomeController>(HomeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              controller.sliderHaberResult.clear();
              return const LoginScreen();
            } else {
              FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).snapshots()
              .forEach((element) async{
                FirebaseFirestore.instance.collection('Users').doc(element.docs.first.id).update(
                  {
                    'token': await AuthService().firebaseMessage.getToken()
                  }
                );
              });
              return HomeScreen();
            }
          }
          return LoadingScreen();
        },
      ),
    );
  }
}
