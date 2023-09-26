import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_info.dart';
import 'package:haber/models/followers_following_model.dart';
import 'package:haber/screens/editprofile_screen.dart';
import 'package:haber/screens/followersdetail_screen.dart';
import 'package:haber/screens/welcome_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:get/get.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> dataS = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('following', arrayContains: AuthService().firebaseAuth.currentUser!.uid)
        .snapshots().forEach((element) {
      for(int i = 0;i<element.size;i++){
        dataS.add(element.docs[i].get('uid'));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Profil Ayarları",style: GoogleFonts.oswald()),
          centerTitle: true,
          toolbarHeight: 65,
          leading: Container()
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available.'));
          }
          final data = snapshot.data!.docs.first;
          if(snapshot.hasData){
            return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/8,
                              child: data.get('imageUrl') != "" ? Image.network(data.get('imageUrl'), fit: BoxFit.cover) : Image.network("https://www.alsekimyamineral.com/Images/resimyok.jpg",fit: BoxFit.cover,),
                            ),
                            Positioned.fill(
                              bottom: -50,
                              left: MediaQuery.of(context).size.width / 3,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                    color: Colors.transparent
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -50,
                              left: MediaQuery.of(context).size.width / 3,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: data.get('imageUrl') != "" ? NetworkImage(data.get('imageUrl')): const NetworkImage("https://www.alsekimyamineral.com/Images/resimyok.jpg"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 58,),
                        Padding(
                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.04,bottom: 10),
                          child: Text(data.get('name'),style: GoogleFonts.oswald(fontSize: 16)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FollowersModel(
                              dataS.length.toString(),
                              "Takipçi",
                                  () {
                                      Get.to(()=>FollowersDetailScreen(dataS,"Takipçi"),transition: Transition.size,duration: const Duration(milliseconds: 1000));
                                    },
                            ),
                            FollowersModel(
                              data.get('following').length.toString(),
                              "Takip",
                                  () {
                                Get.to(()=>FollowersDetailScreen(data.get('following'),"Takip"),transition: Transition.size,duration: const Duration(milliseconds: 1000));
                                  },
                            ),
                          ],
                        ),
                        MyInfo(Icons.mail, data.get('mail')),
                        MyInfo(Icons.person, data.get('bio')),
                        const Divider(color: Colors.white,height: 10),
                        Expanded(
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              ListTile(
                                onTap: () {
                                  Get.to(()=>const EditProfileScreen(),transition: Transition.downToUp,duration: const Duration(milliseconds: 1000));
                                },
                                title: Text("Profili Düzenle",style: GoogleFonts.oswald(),),
                                leading: const Icon(Icons.edit),
                              ),
                              ListTile(
                                onTap: () {
                                  Get.defaultDialog(
                                    content: const Text("Hesabınıza ait tüm içerikler kalıcı olarak silinecek onaylıyor musunuz ?"),
                                    contentPadding: EdgeInsets.all(10),
                                    buttonColor: Colors.red,
                                    cancelTextColor: Colors.white,
                                    confirmTextColor: Colors.white,
                                    textCancel: "Hayır",
                                    textConfirm: "Evet",
                                    title: "Uyarı !",
                                    onConfirm: () async{
                                      QuerySnapshot snapuser = await FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).get();
                                      QuerySnapshot snappost = await FirebaseFirestore.instance.collection('News').doc(AuthService().firebaseAuth.currentUser!.uid).collection('Bookmark').get();
                                      QuerySnapshot snapmessage = await FirebaseFirestore.instance.collection('Messages').where('users',arrayContains: AuthService().firebaseAuth.currentUser!.uid).get();
                                      snapmessage.docs.forEach((element) async{
                                        String id = element.get('docID');
                                        final a = await FirebaseFirestore.instance.collection('Messages').doc(id).collection('message').get();
                                        for (DocumentSnapshot document in a.docs) {
                                          await document.reference.delete();
                                        }
                                      });
                                      for (DocumentSnapshot document in snappost.docs) {
                                        await document.reference.delete();
                                      }for (DocumentSnapshot document in snapmessage.docs) {
                                        await document.reference.delete();
                                      }for (DocumentSnapshot document in snapuser.docs) {
                                        await document.reference.delete();
                                      }
                                      FirebaseAuth.instance.currentUser!.delete();
                                      AuthService().firebaseAuth.signOut();
                                      Get.to(()=>WelcomeScreen());
                                    },
                                  );
                                },
                                title: const Text("Hesabı Sil"),
                                leading: const Icon(Icons.delete),
                              ),
                              ListTile(
                                onTap: () {
                                  Get.defaultDialog(
                                    content: const Text("Çıkış yapmak istiyor musunuz ?"),
                                    contentPadding: EdgeInsets.all(10),
                                    buttonColor: Colors.red,
                                    cancelTextColor: Colors.white,
                                    confirmTextColor: Colors.white,
                                    textCancel: "Hayır",
                                    textConfirm: "Evet",
                                    title: "Dikkat",
                                    onConfirm: () {
                                      AuthService().signOut();
                                      Get.back();
                                    },
                                  );
                                },
                                title: Text("Çıkış Yap",style: GoogleFonts.oswald(color: Colors.red),),
                                leading: const Icon(Icons.logout,color: Colors.red,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                )
            );
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
