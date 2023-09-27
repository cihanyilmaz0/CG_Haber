import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_personaltextfield.dart';
import 'package:haber/models/pick_image.dart';
import 'package:haber/screens/profile_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Uint8List? image;
    void selectImage(ImageSource source) async{
      Uint8List img= await pickImage(source);
      setState(() {
        image=img;
      });
      AuthService().uploadImage('image/${FirebaseAuth.instance.currentUser!.uid}', image!);
      AuthService().saveData(file: image!);
    }
    Future<void> editField(String field,String newValue) async{
      if(newValue.isNotEmpty){
        var a = FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).get();
        a.then((value) => {value.docs.single.reference.update({field:newValue})});
      }
    }
    TextEditingController nameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController bioController = TextEditingController();
    String currentUser = AuthService().firebaseAuth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: MyIconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: currentUser).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/28),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: snapshot.data!.docs.first.get('imageUrl') != "" ? NetworkImage(snapshot.data!.docs.first.get('imageUrl')): NetworkImage("https://www.alsekimyamineral.com/Images/resimyok.jpg"),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 80,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "",
                                  content: Column(
                                    children: [
                                      MyTextButton(
                                        text: "Kameradan Seç",
                                        onTap: () {
                                          selectImage(ImageSource.camera);
                                          Get.back();
                                        },
                                      ),
                                      MyTextButton(
                                        text: "Galeriden Seç",
                                        onTap: () {
                                          selectImage(ImageSource.gallery);
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/18,),
                    MyProfileField(nameController,"Adınız Soyadınız", snapshot.data!.docs.first.get('name').length==0 ? "Adınız Soyadınız" : snapshot.data!.docs.first.get('name')),
                    MyProfileField(usernameController,"Kullanıcı Adınız", snapshot.data!.docs.first.get('username')),
                    MyProfileField(bioController,"Hakkınızda", snapshot.data!.docs.first.get('bio')),
                    MyButton(
                      text: "Kaydet",
                      onTap: () {
                        editField('name', nameController.text);
                        editField('username', usernameController.text);
                        editField('bio', bioController.text);
                        Get.back();
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
            );
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
