import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/screens/detail_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:get/get.dart';

class SavedScreen extends StatefulWidget {
  final String uid;
  final bool isBack;


  SavedScreen(this.uid,this.isBack);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<bool> isBookmarkList = [];

  void isSaved(int index,var degis) async{
    var querySnapshot = await FirebaseFirestore.instance
        .collection('News')
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .collection('Bookmark')
        .where('name', isEqualTo: degis)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        isBookmarkList[index] = true;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isBookmarkList[index] = false;
      });
    }
  }

  void populateBookmarkList() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('News')
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .collection('Bookmark')
        .get();

    setState(() {
      isBookmarkList = List.generate(querySnapshot.docs.length, (index) => true);
    });
  }

  void toggleBookmark(int index, var snap) async{
    setState(() {
      isBookmarkList[index] = !isBookmarkList[index];
    });
    try {
        var degis = await FirebaseFirestore.instance
            .collection('News')
            .doc(AuthService().firebaseAuth.currentUser!.uid)
            .collection('Bookmark')
            .where('name', isEqualTo: snap)
            .get();

        if (degis.docs.isNotEmpty) {
          var docId = degis.docs.first.id;
          await FirebaseFirestore.instance
              .collection('News')
              .doc(AuthService().firebaseAuth.currentUser!.uid)
              .collection('Bookmark')
              .doc(docId)
              .delete();
        }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    populateBookmarkList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text("Kaydedilenler",style: GoogleFonts.oswald()),
            centerTitle: true,
            toolbarHeight: 65,
            leading: widget.isBack ? MyIconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onTap: () {
                Get.back();
              },
            ): Container()
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('News').doc(widget.uid).collection('Bookmark').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length ?? 0,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  isSaved(index, snapshot.data!.docs[index].get('name'));
                  return InkWell(
                    onTap: () {
                      Get.to(()=>DetailScreen(snapshot.data!.docs[index].get('url')),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000));
                    },
                    child: Card(
                      color: Colors.white10,
                      margin: const EdgeInsets.only(left: 8,right: 8,bottom: 6,top: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                              image: DecorationImage(image: NetworkImage(snapshot.data!.docs[index].get('image')),fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.55,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data!.docs[index].get('name')),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.bookmark,),
                                onPressed: () {
                                  toggleBookmark(index, snapshot.data!.docs[index].get('name'));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
