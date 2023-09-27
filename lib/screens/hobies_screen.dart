import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/compenents/my_texticonbutton.dart';
import 'package:haber/main.dart';
import 'package:haber/models/hobies_list.dart';
import 'package:get/get.dart';
import 'package:haber/models/home_page.dart';
import 'package:haber/services/auth_service.dart';

class HobiesScreen extends StatefulWidget {
  const HobiesScreen({super.key});

  @override
  State<HobiesScreen> createState() => _HobiesScreenState();
}

class _HobiesScreenState extends State<HobiesScreen> {
  List<Item> itemList = [];
  List<Item> selectedList=[];

  @override
  void initState() {
    super.initState();
    itemList.add(Item(ad: "Teknoloji",isSelect: false));
    itemList.add(Item(ad: "Ekonomi",isSelect: false));
    itemList.add(Item(ad: "Magazin",isSelect: false));
    itemList.add(Item(ad: "Spor",isSelect: false));


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.defaultDialog(
        backgroundColor: Colors.black54,
        radius: 20,
        content: const Text("Size özel haberleri görmek için lütfen ilgi duyduğunuz alanları seçiniz."),
        title: "Son bir adım kaldı",
        textConfirm: "Tamam",
        buttonColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextIconButton(
              onTap: ()async {
                String uid = AuthService().firebaseAuth.currentUser!.uid;
                try {
                  final userSnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: uid).get();
                  if (userSnapshot.docs.isNotEmpty) {
                    final userDoc = userSnapshot.docs.first.reference;

                    List<String> hobies = [];
                    await userDoc.update({'hobies': hobies});
                    if(mounted){
                      Get.snackbar("İlgi alanlarınız başarıyla kaydedildi.", "Anasayfaya yönlendiriliyorsunuz",snackPosition: SnackPosition.BOTTOM);
                    }
                    Get.to(()=>const HomeScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                  } else {
                    print('User not found');
                  }
                } catch (error) {
                  print('Error updating hobies: $error');
                }
              },
              icon: Icons.arrow_forward_ios,
              text: "Atla",
              alignment: MainAxisAlignment.end,
              textColor: Colors.white,
              leftorright: true,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          itemList[index].isSelect = !itemList[index].isSelect;
                        });
                        if(itemList[index].isSelect){
                          selectedList.add(itemList[index]);
                        }else{
                          selectedList.remove(itemList[index]);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            itemList[index].isSelect ? const Icon(Icons.check_circle) : const Icon(Icons.circle_outlined),
                            const SizedBox(width: 10,),
                            Text(itemList[index].ad,style: const TextStyle(fontSize: 22),textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            MyButton(
              text: "Onayla",
              onTap: () async {
                String uid = AuthService().firebaseAuth.currentUser!.uid;
                try {
                  final userSnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: uid).get();
                  if (userSnapshot.docs.isNotEmpty) {
                    final userDoc = userSnapshot.docs.first.reference;

                    List<String> hobies = [];
                    for (var item in selectedList) {
                      hobies.add(item.ad);
                    }
                    await userDoc.update({'hobies': hobies});
                    if(hobies.isNotEmpty){
                      Get.snackbar("İlgi alanlarınız başarıyla kaydedildi.", "Anasayfaya yönlendiriliyorsunuz",snackPosition: SnackPosition.BOTTOM);
                    }else{
                      Get.snackbar("Uyarı !", "Lütfen seçim yapınız.",snackPosition: SnackPosition.BOTTOM);
                    }
                    runApp(const MyApp());
                    Get.to(()=>const HomeScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
                  } else {
                    print('User not found');
                  }
                } catch (error) {
                  print('Error updating hobies: $error');
                }
              },
              color: Color.fromARGB(100, 100, 100, 100),
              height: 80,
              fontsize: 25,
              padding: 25,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
