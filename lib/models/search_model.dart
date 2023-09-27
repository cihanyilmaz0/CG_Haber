import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/screens/userdetail_screen.dart';
import 'package:haber/services/auth_service.dart';

class SearchModel extends StatelessWidget {
  final String username;


  SearchModel(this.username);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .orderBy('username')
          .startAt([username])
          .endAt([username + '\uf8ff'])
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Container();
        }
        final snap = snapshot.data!.docs;
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if(snap[index].get('uid')==AuthService().firebaseAuth.currentUser!.uid){
                return Container();
              }
              return GestureDetector(
                onTap: () {
                  Get.to(()=>UserDetailScreen(snap[index].get('uid')),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey.shade900,
                  ),
                  height: MediaQuery.of(context).size.height/10,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(snap[index].get('imageUrl')),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(snap[index].get('username')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(snap[index].get('name'),style: GoogleFonts.oswald(color: Colors.grey),),
                          )
                        ],
                      ),
                      const Spacer(),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
