import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haber/screens/detail_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:get/get.dart';

class MessagesModel extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;


  MessagesModel(this.snapshot);

  @override
  State<MessagesModel> createState() => _MessagesModelState();
}

class _MessagesModelState extends State<MessagesModel> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 60),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
          color: Colors.black,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: widget.snapshot.data!.docs[index]['sendBy']==AuthService().firebaseAuth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.snapshot.data!.docs[index]['sendBy']==AuthService().firebaseAuth.currentUser!.uid ? Colors.white : Colors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(8),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width*0.66
                      ),
                      child: widget.snapshot.data!.docs[index]['message'].toString().contains('http')
                          ? AnyLinkPreview(
                        link: widget.snapshot.data!.docs[index]['message'],
                        onTap: () {
                          Get.to(()=>DetailScreen(widget.snapshot.data!.docs[index]['message']),transition: Transition.downToUp,duration: const Duration(milliseconds: 1000));
                        },
                      )
                          : Text(widget.snapshot.data!.docs[index]['message'],style: TextStyle(color: Colors.black),),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
