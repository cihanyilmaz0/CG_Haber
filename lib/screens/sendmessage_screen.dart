import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:get/get.dart';
import 'package:haber/models/messages_model.dart';
import 'package:haber/screens/userdetail_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:haber/services/post_message.dart';

class SendMessageScreen extends StatefulWidget {
  final String alan;
  final String yollayan;
  final String url;
  final String kadi;


  SendMessageScreen({required this.alan, required this.yollayan,required this.url,required this.kadi});

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  TextEditingController controller = TextEditingController();
  FocusNode? focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          focus!.unfocus();
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              child: Row(
                children: [
                  MyIconButton(
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        if(widget.yollayan != AuthService().firebaseAuth.currentUser!.uid){
                          Get.to(()=>UserDetailScreen(widget.yollayan),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                        }else{
                          Get.to(()=>UserDetailScreen(widget.alan),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                        }
                      },
                      child: Text(widget.kadi, style: GoogleFonts.oswald(fontSize: 18),)
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if(widget.yollayan != AuthService().firebaseAuth.currentUser!.uid){
                        Get.to(()=>UserDetailScreen(widget.yollayan),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                      }else{
                        Get.to(()=>UserDetailScreen(widget.alan),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                      }
                      },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.url),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Messages')
                    .doc('${widget.yollayan}-${widget.alan}')
                    .collection('message')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Veri okuma hatası: ${snapshot.error}');
                  }
                  if (snapshot.data!.docs.isNotEmpty) {
                    if (snapshot.data!.docs[0]['sendBy'] !=
                        AuthService().firebaseAuth.currentUser!.uid) {
                      snapshot.data!.docs.forEach((element) {
                        element.reference.update(
                            {
                              'isRead': true
                            });
                      });
                    }
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Messages')
                            .doc('${widget.alan}-${widget.yollayan}')
                            .collection('message')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Veri okuma hatası: ${snapshot.error}');
                          }
                          if (snapshot.data!.docs.isNotEmpty) {
                            if (snapshot.data!.docs[0]['sendBy'] !=
                                AuthService().firebaseAuth.currentUser!.uid) {
                              snapshot.data!.docs.forEach((element) {
                                element.reference.update(
                                    {
                                      'isRead': true
                                    });
                              });
                            }
                          }
                          return MessagesModel(snapshot);
                        }
                    );
                  }
                  return MessagesModel(snapshot);
                }
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height/20,
            width: MediaQuery.of(context).size.width/1.3,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
              controller: controller,
              focusNode: focus,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade600,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          MyIconButton(
            icon: const Icon(Icons.send),
            onTap: () async{
              bool hasData= await PostMessage().checkAndRetrieveData("${widget.yollayan}-${widget.alan}");
              if(hasData){
                PostMessage().postMessage(hasData,"${widget.yollayan}-${widget.alan}",widget.yollayan,widget.alan,controller.text);
              }
              else{
                bool hasData2= await PostMessage().checkAndRetrieveData("${widget.alan}-${widget.yollayan}");
                if(hasData2){
                  PostMessage().postMessage(hasData2,"${widget.alan}-${widget.yollayan}",widget.yollayan,widget.alan,controller.text);
                }else{
                  PostMessage().postMessage(hasData2,"${widget.yollayan}-${widget.alan}",widget.yollayan,widget.alan,controller.text);
                }
              }
              controller.clear();
            },
          ),
        ],
      )
    );
  }
}