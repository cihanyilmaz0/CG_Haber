import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haber/compenents/my_textfield.dart';
import 'package:haber/models/sendandsearch_model.dart';
import 'package:haber/services/auth_service.dart';

class MyShowJustBottom extends StatefulWidget {
  final TextEditingController _controller;
  final String news;


  MyShowJustBottom(this._controller,this.news);

  @override
  State<MyShowJustBottom> createState() => _MyShowJustBottomState();
}

class _MyShowJustBottomState extends State<MyShowJustBottom> {
  List<String> followingList = [];
  List<String> selectedList = [];

  Future<List<String>> getFollowing() async {
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
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.2,
      child: FutureBuilder(
        future: getFollowing(),
        builder: (context, snapshot) {
          return  StreamBuilder(
            stream: followingList.isNotEmpty && widget._controller.text.isEmpty ?
            FirebaseFirestore.instance
                .collection('Users')
                .where('uid', whereIn: followingList)
                .snapshots()
                : FirebaseFirestore.instance
                .collection('Users')
                .orderBy('username')
                .startAt([widget._controller.text])
                .endAt([widget._controller.text + '\uf8ff'])
                .snapshots(),
            builder: (context, snapshot) {
              if(followingList.isEmpty){
                return const Center(child: CircularProgressIndicator(color: Colors.grey,),);
              }
              final snap = snapshot.data!.docs;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(100))
                      ),
                    ),
                  ),
                  MySearchField(
                      widget._controller,
                      null,
                          (value) {setState(() {});}
                  ),
                  widget._controller.text.isEmpty ? SendSearchModel(snap, selectedList,widget.news) : SendSearchModel(snap, selectedList,widget.news),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
