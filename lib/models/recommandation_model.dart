import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_showjustbottombar.dart';
import 'package:haber/screens/detail_screen.dart';
import 'package:haber/services/auth_service.dart';

class Recommandation extends StatefulWidget {
  final RxList<dynamic> list;
  final ScrollPhysics physics;
  final int count;


  Recommandation({required this.list,required this.count,required this.physics});

  @override
  State<Recommandation> createState() => _RecommandationState();
}




class _RecommandationState extends State<Recommandation> {
  List<bool> isBookmarkList = [];
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    isBookmarkList = List.generate(widget.count, (index) => false);
    super.initState();
  }

  void isSaved(int index) async {
    if (!mounted) return;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('News')
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .collection('Bookmark')
        .where('name', isEqualTo: widget.list[index].name)
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

  void toggleBookmark(int index) async{
    setState(() {
      isBookmarkList[index] = !isBookmarkList[index];
    });

    DocumentReference postRef =
    FirebaseFirestore.instance.collection('News').doc(AuthService().firebaseAuth.currentUser!.uid).collection('Bookmark').doc();

    try {
      if (isBookmarkList[index]) {
        await postRef.set({
          'url': widget.list[index].url,
          'name':widget.list[index].name,
          'image':widget.list[index].image,
        });
      } else {
        var degis = await FirebaseFirestore.instance
            .collection('News')
            .doc(AuthService().firebaseAuth.currentUser!.uid)
            .collection('Bookmark')
            .where('name', isEqualTo: widget.list[index].name)
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
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: widget.count,
          physics: widget.physics,
          itemBuilder: (context, index) {
            isSaved(index);
            return InkWell(
              onTap: () {
                Get.to(()=>DetailScreen(widget.list[index].url),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 1000));
              },
              child: Card(
                color: Colors.white10,
                margin: const EdgeInsets.only(left: 8,right: 8,bottom: 6),
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
                        image: DecorationImage(image: NetworkImage(widget.list[index].image),fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.55,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.list[index].name),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 6),
                            child: Text("Kaynak: "+widget.list[index].source),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        MyIconButton(
                          icon: Icon(
                            isBookmarkList[index] ? Icons.bookmark : Icons.bookmark_border ,
                          ),
                          onTap: () {
                            toggleBookmark(index);
                          },
                        ),
                        MyIconButton(
                          icon: const Icon(Icons.send),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return MyShowJustBottom(_controller, widget.list[index].url);
                                });
                            },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}