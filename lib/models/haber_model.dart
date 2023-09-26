// To parse this JSON data, do
//
//     final haber = haberFromJson(jsonString);

import 'dart:convert';

Haber haberFromJson(String str) => Haber.fromJson(json.decode(str));

String haberToJson(Haber data) => json.encode(data.toJson());

class Haber {
  bool success;
  List<dynamic> result;

  Haber({
    required this.success,
    required this.result,
  });

  factory Haber.fromJson(Map<String, dynamic> json) => Haber(
    success: json["success"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result.map((x) => x)),
  };
}

class ResultClass {
  String key;
  String url;
  String description;
  String image;
  String name;
  String source;

  ResultClass({
    required this.key,
    required this.url,
    required this.description,
    required this.image,
    required this.name,
    required this.source,
  });

  factory ResultClass.fromJson(Map<String, dynamic> json) => ResultClass(
    key: json["key"],
    url: json["url"],
    description: json["description"],
    image: json["image"],
    name: json["name"],
    source: json["source"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "url": url,
    "description": description,
    "image": image,
    "name": name,
    "source": source,
  };
}
