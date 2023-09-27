import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/screens/sendmessage_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> following = [];

  Future<List<String>> getFollowing() async {
    List<String> followingList = [];
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('uid',isEqualTo: AuthService().firebaseAuth.currentUser!.uid)
          .get();
      var userData = querySnapshot.docs.first.data();
      if (userData != null && userData['following'] != null) {
        followingList = List<String>.from(userData['following']);
      }
    } catch (e) {
      print('Hata: $e');
    }
    return followingList.isNotEmpty ? followingList : [];
  }

  @override
  void initState() {
    getFollowing().then((followingList) {
      setState(() {
        following = followingList;
      });
    });
    super.initState();
  }

  Future getUserDetail(String gonderenid) async {

    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: gonderenid)
        .limit(1)
        .get();

    if (userQuerySnapshot.size > 0) {
      DocumentSnapshot userSnapshot = userQuerySnapshot.docs[0];
      return userSnapshot.data();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text("Mesajlar",style: GoogleFonts.oswald()),
            centerTitle: true,
            toolbarHeight: 65,
            leading: Container()
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: following.isNotEmpty ?
              FirebaseFirestore.instance
                  .collection('Users')
                  .where('uid', whereIn: following)
                  .snapshots()
                  : null,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height/5,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("Takip ettiğiniz kimse yok."),
                    ),
                  );
                }else if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }else{
                  final snap = snapshot.data!.docs;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height/5,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(()=>
                                SendMessageScreen(
                                    alan: snap[index].get('uid'),
                                    yollayan: AuthService().firebaseAuth.currentUser!.uid,
                                    url: snap[index].get('imageUrl'),
                                    kadi: snap[index].get('username')
                                ),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000)
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage(snap[index].get('imageUrl')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8,right: 8),
                                child: Text(snap[index].get('username'),style: GoogleFonts.oswald(fontSize: 16)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Messages').where('users', arrayContains: AuthService().firebaseAuth.currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Veriler yüklenirken bir hata oluştu.'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Hiç mesajınız yok"),
                  );
                }
                List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                return Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                        color: Colors.black54
                    ),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final messageRef = data[index].reference.collection('message');
                        return StreamBuilder(
                          stream: messageRef.orderBy('time', descending: true).limit(1).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Veriler yüklenirken bir hata oluştu: ${snapshot.error.toString()}'),
                              );
                            }if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('Hiç mesajınız yok.'),
                              );
                            }
                            final messageData = snapshot.data!.docs.first.data();
                            return FutureBuilder(
                              future: data[index].id.split('-')[0] == AuthService().firebaseAuth.currentUser!.uid ?
                              getUserDetail(data[index].id.split('-')[1]) :
                              getUserDetail(data[index].id.split('-')[0]),
                              builder: (context, snapshot) {
                                String message = messageData['message'].length>50 ? messageData['message'].substring(0,50) + "..." : messageData['message'];
                                var result = snapshot.data;
                                if(snapshot.hasData){
                                  return ListTile(
                                    title: Text(result['username']),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                      backgroundImage: NetworkImage(result['imageUrl']),
                                    ),
                                    subtitle: Text(message),
                                    trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width/5,
                                      child: Row(
                                        children: [
                                          Text(DateFormat('HH:mm').format(messageData['time'].toDate()).toString()),
                                          const Spacer(),
                                          messageData['isRead'] || messageData['sendBy']==AuthService().firebaseAuth.currentUser!.uid
                                              ? Container() :
                                          const CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            radius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      Get.to(()=>SendMessageScreen(
                                        yollayan: AuthService().firebaseAuth.currentUser!.uid,
                                        alan: data[index].id.split('-')[0] == AuthService().firebaseAuth.currentUser!.uid
                                            ? data[index].id.split('-')[1]
                                            : data[index].id.split('-')[0],
                                        url: result['imageUrl'],
                                        kadi: result['username'],
                                      ),
                                          transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000)
                                      );
                                    },
                                  );
                                }else{
                                  return const Center(child: CircularProgressIndicator());
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}