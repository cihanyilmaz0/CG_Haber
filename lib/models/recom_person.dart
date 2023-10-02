import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/screens/userdetail_screen.dart';
import 'package:haber/services/auth_service.dart';

class RecomPerson extends StatelessWidget {
  const RecomPerson({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final allUsers = snapshot.data!.docs;
        final currentUserUid = AuthService().firebaseAuth.currentUser!.uid;
        final snap = snapshot.data!.docs;
        List<dynamic> following = snap
            .firstWhere((userSnapshot) => userSnapshot['uid'] == currentUserUid)
            .get('following');
        final notFollowing = allUsers.where((userSnapshot) {
          final userUid = userSnapshot['uid'];
          return userUid != currentUserUid && !following.contains(userUid);
        }).toList();
        if(notFollowing.isEmpty){
          return Container();
        }
        return SizedBox(
          height: 136,
          child: ListView.builder(
            itemCount: notFollowing.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final userData = notFollowing[index].data();
              return GestureDetector(
                onTap: () {
                  Get.to(()=>UserDetailScreen(userData['uid']),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade800
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3,bottom: 4),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(userData['imageUrl']),
                        ),
                      ),
                      Expanded(child: Text(userData['username'])),
                      userData['name'] !="" ? Expanded(child: Text(userData['name'],style: GoogleFonts.oswald(fontSize: 12))) : Container(),
                      MyButton(
                        padding: 0,
                        width: 80,
                        height: 30,
                        color: Colors.blue,
                        text: "Takip Et",
                        fontsize: 12,
                        onTap: () async{
                          var degis =
                              await FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: currentUserUid).get();
                          degis.docs.first.reference.update({
                            'following' : FieldValue.arrayUnion([userData['uid']])
                          });
                        },
                      ),
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
