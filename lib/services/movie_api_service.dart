import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_detail.dart';

  class MovieApiService {
    static const String baseUrl = "https://phimapi.com";


  //phim moi
  static Future<List<Movie>> getLatestMovies() async{
    try{
     final response = await http.get(Uri.parse("$baseUrl/danh-sach/phim-moi-cap-nhat"));
      final data = jsonDecode(response.body);
      List<Movie> listMovie = [];
      for(var item in data["items"]){
        listMovie.add(Movie.fromJson(item));
      }

      return listMovie;
    } catch (e) {
        print(e);
        return [];
    }
  }


  //tim kiem
  static Future<List<Movie>> searchMovies(String keyword) async{
    try{
      final response = await http.get(
          Uri.parse(
              "$baseUrl/v1/api/tim-kiem?keyword=${Uri.encodeComponent(keyword)}")
      );
      final data = jsonDecode(response.body);
      List<Movie> listMovie = [];
      for(var item in data["data"]["items"] ?? []){
        listMovie.add(Movie.fromJson(item));
      }
      return listMovie;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //chi tiet phim
  static Future<MovieDetail?> getMovieDetail(String slug) async{
    try{
      final response = await http.get(Uri.parse("$baseUrl/phim/$slug"));
      final data = jsonDecode(response.body);
      return MovieDetail.fromApiResponse(data);
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  //phim theo the loai
  static Future<List<Movie>> getMoviesByCategory(String slug) async{
    try{
      final response = await http.get(Uri.parse("$baseUrl/v1/api/the-loai/$slug"));
      final data = jsonDecode(response.body);
      List<Movie> listMovie = [];
      for(var item in data["data"]["items"]){
        listMovie.add(Movie.fromJson(item));
      }
      return listMovie;
    } catch (e) {
      print(e);
      return [];
    }
  }


}