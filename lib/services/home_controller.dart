import 'package:get/get.dart';
import 'package:haber/models/haber_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var sliderHaberResult = [].obs;
  var magazineHaberResult = [].obs;
  var technologyHaberResult = [].obs;
  var economyHaberResult = [].obs;
  var sportHaberResult = [].obs;

  var isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData("general", sliderHaberResult);
    loadPersonalNews();
  }

  loadData(String tag, List targetList) async {
    final headers = {
      'authorization': 'apikey 0we2fMY2adLunH7fVrLrvS:07MRcvVraw7KL4WAKIarRt',
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

  loadPersonalNews() async {
    loadData("magazine", magazineHaberResult);
    loadData("technology", technologyHaberResult);
    loadData("economy", economyHaberResult);
    loadData("sport", sportHaberResult);
  }
}