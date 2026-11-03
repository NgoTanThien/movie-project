import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Movie {
  String name;
  String slug;
  String posterUrl;
  String description;
  int year;
  List<String> categories;
  String language;

  Movie({
    required this.name,
    required this.slug,
    required this.posterUrl,
    required this.description,
    required this.year,
    required this.categories,
    required this.language,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String> listCategory = [];
    if(json["category"] != null){
      for(var item in json["category"]){
        listCategory.add(item["name"] ?? "");
      }
    }

    String poster = "";
    if(json["poster_url"] != null && json["poster_url"].toString().isNotEmpty){
      poster = json["poster_url"];
    } else if(json["thumb_url"] != null){
      poster = json["thumb_url"];
    }

    if(poster.isNotEmpty && !poster.startsWith("http")){
      poster =  "https://phimimg.com/$poster";
    }
    int nam = 0;
    if(json["year"] is int) {
      nam = json["year"];
    }else{
      nam = int.tryParse(json["year"].toString()) ?? 0;
    }

    String ngonNgu = json["lang"] ?? "Vietsub";

    return Movie(
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      posterUrl: poster,
      description: json["content"] ?? "",
      year: nam,
      categories: listCategory,
      language: ngonNgu
    );
  }



}