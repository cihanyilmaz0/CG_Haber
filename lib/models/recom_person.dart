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
          height: MediaQuery.of(context).size.height/3.5,
          child: ListView.builder(
            itemCount: notFollowing.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final userData = notFollowing[index].data();
              return GestureDetector(
                onTap: () {
                  Get.to(()=>UserDetailScreen(userData['uid']),transition: Transition.upToDown,duration: const Duration(milliseconds: 1000));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade800
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(userData['imageUrl']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(userData['username']),
                      ),
                      Text(userData['name'],style: GoogleFonts.oswald(fontSize: 12)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: MyButton(
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
