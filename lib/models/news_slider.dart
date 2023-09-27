import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber/screens/detail_screen.dart';
import 'package:haber/services/home_controller.dart';

class SliderNews extends StatelessWidget {
  const SliderNews({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<HomeController>(HomeController());
    return Obx(
      () => controller.isDataLoading.value ? CarouselSlider.builder(
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        itemCount: controller.sliderHaberResult.length,
        itemBuilder: (context, index, realIndex) {
          if(controller.sliderHaberResult.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return InkWell(
            onTap: () {
              Get.to(()=>DetailScreen(controller.sliderHaberResult[index].url),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 600));
            },
            child: Stack(
              children: [
                controller.sliderHaberResult[index].image != "" ?
                Image.network(controller.sliderHaberResult[index].image,fit: BoxFit.cover,height: 300,width: 350) : Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2lQwF4OyABREYJm3Uedi_YH5G5OF-2KEmRCUewDJwtA&s",fit: BoxFit.cover,height: 300,width: 350),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.2,0.5, 0.6,
                      ],
                      colors: [
                        Colors.transparent, Colors.black38, Color.fromARGB(180, 0, 0, 0)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 20,
                  child: Text(controller.sliderHaberResult[index].name),width: MediaQuery.of(context).size.width/1.5,)
              ],
            ),
          );
        },
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }
}
