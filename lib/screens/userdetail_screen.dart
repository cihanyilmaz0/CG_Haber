import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_info.dart';
import 'package:haber/models/followers_following_model.dart';
import 'package:haber/screens/followersdetail_screen.dart';
import 'package:haber/screens/saved_screen.dart';
import 'package:haber/services/auth_service.dart';

class UserDetailScreen extends StatefulWidget {
  final String uid;


  UserDetailScreen(this.uid);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  List<dynamic> dataS = [];
  bool follow = false;

  void isFollow(){
    FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).snapshots()
        .forEach((element) {
      if(element.docs.first.get('following').contains(widget.uid)){
        follow = true;
      }
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('following', arrayContains: widget.uid)
        .snapshots().forEach((element) {
      for(int i = 0;i<element.size;i++){
        dataS.add(element.docs[i].get('uid'));
      }
    });
    isFollow();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişi Bilgisi"),
        centerTitle: true,
        toolbarHeight: 65,
        leading: MyIconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: widget.uid).snapshots(),
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
                                Get.to(()=>FollowersDetailScreen(dataS,"Takipçi"),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000));
                              },
                            ),
                            FollowersModel(
                              data.get('following').length.toString(),
                              "Takip",
                                  () {
                                Get.to(()=>FollowersDetailScreen(data.get('following'),"Takip"),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000));
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
                                  Get.to(()=>SavedScreen(data.get('uid'),true),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000));
                                },
                                title: Text("Kaydedilen Haberler",style: GoogleFonts.oswald(),),
                                leading: const Icon(Icons.bookmark),
                              ),
                              MyButton(
                                width: 0,
                                height: 60,
                                color: follow ? Colors.grey : Colors.blue,
                                fontsize: 16,
                                text: follow ? "Takipten Çıkar" :"Takip Et",
                                padding: 0,
                                onTap: () async{
                                  if(follow){
                                    var degis =
                                        await FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).get();
                                    degis.docs.first.reference.update({
                                      'following' : FieldValue.arrayRemove([widget.uid])
                                    });
                                    setState(() {
                                      follow = !follow;
                                    });
                                  }else{
                                    var degis =
                                    await FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).get();
                                    degis.docs.first.reference.update({
                                      'following' : FieldValue.arrayUnion([widget.uid])
                                    });
                                    setState(() {
                                      follow = !follow;
                                    });
                                  }
                                },
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
