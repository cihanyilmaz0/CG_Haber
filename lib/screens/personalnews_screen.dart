import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:haber/models/recommandation_model.dart';
import 'package:get/get.dart';
import 'package:haber/services/home_controller.dart';

class PersonalNewsScreen extends StatefulWidget {
  final List<String> list;

  PersonalNewsScreen(this.list);

  @override
  State<PersonalNewsScreen> createState() => _PersonalNewsScreenState();
}

class _PersonalNewsScreenState extends State<PersonalNewsScreen> {
  int selectedIndex = 0;
  String hobiesString ="";
  final controller = Get.put<HomeController>(HomeController());
  @override
  void initState() {
    hobiesString = widget.list[selectedIndex];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Size Özel", style: GoogleFonts.oswald()),
        centerTitle: true,
        toolbarHeight: 65,
        elevation: 0,
        leading: MyIconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          controller.loadPersonalNews();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: List.generate(
                  widget.list.length,
                      (index) {
                    final item = widget.list[index];
                    final isSelected = index == selectedIndex;
                    return Padding(
                          padding: const EdgeInsets.all(6),
                          child: FilterChip(
                            label: Text(item),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedIndex = index;
                                hobiesString = item;
                              });
                            },
                            selectedColor: Colors.blue,
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.grey.shade700,
                          ),
                    );
                  },
                ),
              ),
              hobiesString == "Magazin" ?
              Expanded(child: Recommandation(list: controller.magazineHaberResult,count: controller.magazineHaberResult.length, physics: const BouncingScrollPhysics()))
                  : hobiesString == "Ekonomi" ?
              Expanded(child: Recommandation(list: controller.economyHaberResult,count: controller.economyHaberResult.length, physics: const BouncingScrollPhysics()))
                  : hobiesString == "Teknoloji" ?
              Expanded(child: Recommandation(list: controller.technologyHaberResult,count: controller.technologyHaberResult.length, physics: const BouncingScrollPhysics()))
                  : hobiesString == "Spor" ?
              Expanded(child: Recommandation(list: controller.sportHaberResult,count: controller.sportHaberResult.length, physics: const BouncingScrollPhysics()))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
