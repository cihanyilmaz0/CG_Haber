import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:haber/models/haber_model.dart';
import 'package:haber/services/auth_service.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var sliderHaberResult = [].obs;
  var listHaberResult = [].obs;
  var magazineHaberResult = [].obs;
  var technologyHaberResult = [].obs;
  var economyHaberResult = [].obs;
  var sportHaberResult = [].obs;

  List<String> hobiesList=[];
  String hobiesString="";
  var isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData("general", sliderHaberResult);
  }

  loadData(String tag, List targetList) async {
    final headers = {
      'authorization': 'apikey 4dXRW9rjmMnIwh4l3jEGsZ:2kHwvI9yMsveUWWv3dq39S',
      'content-type': 'application/json',
    };
    final params = {
      'country': 'tr',
      'tag': tag,
    };
    final url = Uri.parse('https://api.collectapi.com/news/getNews')
        .replace(queryParameters: params);
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var result = haberFromJson(response.body);
        targetList.clear();
        targetList.addAll(
            result.result.map((item) => ResultClass.fromJson(item)));
        isDataLoading.value = true;
        update();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  loadHobies() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: AuthService().firebaseAuth.currentUser!.uid)
        .get();

    hobiesList = snap.docs.first.get('hobies').cast<String>();
    if (hobiesList.isEmpty) {
      hobiesString = "";
    } else {
      hobiesString = hobiesList.last;
    }
    if (hobiesString == "Magazin") {
      loadData("magazine", listHaberResult);
    }
    if (hobiesString == "Ekonomi") {
      loadData("economy", listHaberResult);
    }
    if (hobiesString == "Teknoloji") {
      loadData("technology", listHaberResult);
    }
    if (hobiesString == "Spor") {
      loadData("Sport", listHaberResult);
    }
    if (hobiesString == "") {
      loadData("general", listHaberResult);
    }
  }

  loadPersonalNews() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: AuthService().firebaseAuth.currentUser!.uid)
        .get();

    hobiesList = snap.docs.first.get('hobies').cast<String>();
    for (int i = 0; i < hobiesList.length; i++) {
      if(hobiesList[i] == "Magazin"){
        loadData("magazine", magazineHaberResult);
      }if(hobiesList[i]=="Teknoloji"){
        loadData("technology", technologyHaberResult);
      }if(hobiesList[i]=="Ekonomi"){
        loadData("economy", economyHaberResult);
      }if(hobiesList[i]=="Spor"){
        loadData("sport", sportHaberResult);
      }
    }
  }
}