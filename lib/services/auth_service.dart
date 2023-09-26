import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final firebaseMessage = FirebaseMessaging.instance;

  Future<User?> register(String email, String password,BuildContext context)async{
    try{
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return user.user;
    }on FirebaseAuthException catch(e){
      Get.snackbar("Hata",e.message.toString(),snackPosition: SnackPosition.BOTTOM);
    }catch(e){
      print(e);
    }
  }

  Future<User?> login(String email, String password,BuildContext context)async{
    try{
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return user.user;
    }on FirebaseAuthException catch(e){
      Get.snackbar("Hata",e.message.toString(),snackPosition: SnackPosition.BOTTOM);
    }catch(e){
      print(e);
    }
  }
  Future<User?> signinWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser != null){
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );

        UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
        return userCredential.user;
      }
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async{
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }

  Future<String> uploadImage(String childName,Uint8List file) async {
    Reference ref = storage.ref().child(childName);
    UploadTask task = ref.putData(file);
    TaskSnapshot snapshot = await task;
    String downloadUrl= await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future saveData({required Uint8List file}) async{
    try{
      String imgUrl= await uploadImage('image/${FirebaseAuth.instance.currentUser!.uid}', file);
      var a = FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).get();
      a.then((value) => {value.docs.single.reference.update({'imageUrl':imgUrl})});
    }catch(e){
      print(e.toString());
    }
  }
}