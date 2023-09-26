import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/services/auth_service.dart';
import 'package:haber/services/post_message.dart';
import 'package:get/get.dart';

class SendSearchModel extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String,dynamic>>> snap;
  final List<dynamic> selectedList;
  final String news;


  SendSearchModel(this.snap, this.selectedList,this.news);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              itemCount: snap.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedList.contains(snap[index].get('uid'))) {
                        selectedList.remove(snap[index].get('uid'));
                      } else {
                        selectedList.add(snap[index].get('uid'));
                      }
                    });
                  },
                  child: snap[index].get('uid') != AuthService().firebaseAuth.currentUser!.uid ? Card(
                    color: Colors.grey.shade800,
                    margin: const EdgeInsets.all(10),
                    shape: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide.none
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 8),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(snap[index].get('imageUrl')),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(snap[index].get('username'), style: GoogleFonts.oswald(fontSize: 16)),
                            Text(snap[index].get('name'), style: GoogleFonts.oswald(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            selectedList.contains(snap[index].get('uid'))
                                ? Icons.check_circle_outline
                                : Icons.circle_outlined,
                            color: selectedList.contains(snap[index].get('uid'))
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ): Container(),
                );
              },
            ),
            selectedList.isNotEmpty ? MyButton(
              onTap: () async {
                for (int i = 0; i < selectedList.length; i++) {
                  String recipientUid = selectedList[i];
                  bool hasData = await PostMessage().checkAndRetrieveData("${AuthService().firebaseAuth.currentUser!.uid}-$recipientUid");
                  if (hasData) {
                    PostMessage().postMessage(hasData, "${AuthService().firebaseAuth.currentUser!.uid}-$recipientUid", AuthService().firebaseAuth.currentUser!.uid, recipientUid, news);
                  } else {
                    bool hasData2 = await PostMessage().checkAndRetrieveData("$recipientUid-${AuthService().firebaseAuth.currentUser!.uid}");
                    if (hasData2) {
                      PostMessage().postMessage(hasData2, "$recipientUid-${AuthService().firebaseAuth.currentUser!.uid}", AuthService().firebaseAuth.currentUser!.uid, recipientUid, news);
                    } else {
                      PostMessage().postMessage(hasData2, "${AuthService().firebaseAuth.currentUser!.uid}-$recipientUid", AuthService().firebaseAuth.currentUser!.uid, recipientUid, news);
                    }
                  }
                }
                Get.back();
              },
              text: "Gönder",
              color: Colors.blue,
              height: 50,
              width: MediaQuery.of(context).size.width,
              fontsize: 18,
              padding: 0,
            ) : Container(),
          ],
        );
      },
    );
  }
}
