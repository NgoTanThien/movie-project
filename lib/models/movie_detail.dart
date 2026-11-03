import 'package:movie/models/episode.dart';

class MovieDetail{
  String name;
  String slug;
  String posterUrl;
  String description;
  int year;
  List<String> categories;
  String quality;
  String language;
  String episodeCount;
  List<Episode> episodes;
  String director;
  List<String> actors;
  String country;
  int time;

  MovieDetail({
    required this.name,
    required this.slug,
    required this.posterUrl,
    required this.description,
    required this.year,
    required this.categories,
    required this.quality,
    required this.language,
    required this.episodeCount,
    required this.episodes,
    required this.director,
    required this.actors,
    required this.country,
    required this.time,
  });

  factory MovieDetail.fromApiResponse(Map<String, dynamic> json){
    return MovieDetail.fromJson(
      json["movie"],
      json["episodes"] ?? []
    );
  }

  factory MovieDetail.fromJson(Map<String, dynamic> movieJson, List<dynamic> episodeJson){
    List<String> listCategory = [];

    if(movieJson["category"] != null){
      for(var item in movieJson["category"]){
        listCategory.add(item["name"] ?? "");
      }
    }
    List<Episode> listEpisode = [];
    for(var item in episodeJson) {
      listEpisode.add(Episode.fromJson(item));
    }

    List<String> listActor = [];
    if(movieJson["actor"] != null){
      for(var item in movieJson["actor"]){
        listActor.add(item.toString());
      }
    }

    String tenQuocGia = "";
    if(movieJson["country"] != null &&
        movieJson["country"].isNotEmpty) {
      tenQuocGia = movieJson["country"][0]["name"] ?? "";
    }

    String daoDien = "";
    if(movieJson["director"] != null){
      if(movieJson["director"] is List){
        daoDien = movieJson["director"].join(",");
      }else{
        daoDien = movieJson["director"].toString();
      }
    }

    int nam = 0;
    if(movieJson["year"] is int){
      nam = movieJson["year"];
    }else{
      nam = int.tryParse(movieJson["year"].toString()) ?? 0;
    }

    int thoiLuong = int.tryParse(movieJson["time"].toString()) ?? 0;

    return MovieDetail(
        name: movieJson["name"] ?? "",
        slug: movieJson["slug"] ?? "",
        posterUrl: movieJson["poster_url"] ?? "",
        description: movieJson["content"] ?? "",
        year: nam,
        categories: listCategory,
        quality: movieJson["quality"] ?? "",
        language: movieJson["lang"] ?? "VietSub",
        episodeCount: movieJson["episode_count"] ?? "",
        episodes: listEpisode,
        director: daoDien,
        actors: listActor,
        country: tenQuocGia,
        time: thoiLuong
    );

  }


}