import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/models/news_slider.dart';
import 'package:get/get.dart';
import 'package:haber/models/recom_person.dart';
import 'package:haber/models/recommandation_model.dart';
import 'package:haber/screens/personalnews_screen.dart';
import 'package:haber/screens/search_screen.dart';
import 'package:haber/services/home_controller.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final homeController = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CG Haber",style: GoogleFonts.oswald()),
        centerTitle: true,
        toolbarHeight: 65,
        leading: Container(),
        actions: [
          MyIconButton(
            icon: const Icon(Icons.search),
            onTap: () {
              Get.to(()=>const SearchScreen(),transition: Transition.cupertino,duration: const Duration(milliseconds: 1000));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          homeController.loadData("general", homeController.sliderHaberResult);
          homeController.loadHobies();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 8,left: 18),
                        child: Text("Son Dakika",style: GoogleFonts.oswald(fontSize: 24,fontWeight: FontWeight.bold))),
                  ],
                ),
                const Divider(color: Colors.white,height: 30),
                const SliderNews(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: RecomPerson(),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text("Size Özel Haberler",style: GoogleFonts.oswald(fontSize: 24,fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    TextButton(
                      child: Text("Tümünü gör",style: GoogleFonts.aBeeZee(color: Colors.blue)),
                      onPressed: () {
                        Get.to(()=>PersonalNewsScreen(homeController.hobiesList),transition: Transition.leftToRightWithFade,duration: const Duration(milliseconds: 1000));
                      },
                    ),
                  ],
                ),
                Obx(
                    () => homeController.isDataLoading.value && homeController.listHaberResult.isNotEmpty ?
                    Recommandation(list: homeController.listHaberResult,count: 2,physics: const NeverScrollableScrollPhysics()) :
                  const Center(child: CircularProgressIndicator(),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}