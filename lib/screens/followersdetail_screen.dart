import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:get/get.dart';
import 'package:haber/screens/userdetail_screen.dart';
import 'package:haber/services/auth_service.dart';

class FollowersDetailScreen extends StatefulWidget {
  final List<dynamic> followUid;
  final String app;


  FollowersDetailScreen(this.followUid,this.app);

  @override
  State<FollowersDetailScreen> createState() => _FollowersDetailScreenState();
}

class _FollowersDetailScreenState extends State<FollowersDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.app,style: GoogleFonts.oswald()),
          centerTitle: true,
          toolbarHeight: 65,
          leading: MyIconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onTap: () {
              Get.back();
            },
          ),
      ),
      body: Center(
          child: ListView.builder(
            itemCount: widget.followUid.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: widget.followUid[index]).snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return const Center(child: Text("Veri yok"),);
                    }
                    final snap = snapshot.data!.docs;
                    return GestureDetector(
                      onTap: () {
                        Get.to(()=>UserDetailScreen(snap.first.get('uid')),transition: Transition.upToDown,duration: const Duration(milliseconds: 1000));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        color: Colors.grey.shade900,
                        shape: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(snap.first.get('imageUrl')),
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snap.first.get('username'),style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snap.first.get('name'),style: TextStyle(fontSize: 14,color: Colors.grey)),
                                ),
                              ],
                            ),
                            Spacer(),
                            widget.app == "Takip" ? Padding(
                              padding: const EdgeInsets.all(6),
                              child: MyButton(
                                padding: 0,
                                width: 80,
                                height: 30,
                                color: Colors.grey,
                                text: "Kaldır",
                                fontsize: 12,
                                onTap: () async{
                                  var degis =
                                      await FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid).get();
                                  degis.docs.first.reference.update({
                                    'following' : FieldValue.arrayRemove([snap.first.get('uid')])
                                  });
                                  widget.followUid.remove(snap.first.get('uid'));
                                  setState(() {

                                  });
                                },
                              ),
                            ):Container(),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
          )
      ),
    );
  }
}
