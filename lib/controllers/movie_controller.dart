import 'package:get/get.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_detail.dart';
import 'package:movie/services/movie_api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MovieController  extends GetxController {
  List<Movie> listMovie = [];
  List<Movie> listWatchLater = [];
  MovieDetail? movieDetail;
  bool isLoading = false;
  String error = "";
  final SupabaseClient supabase = Supabase.instance.client;
  final AuthController authController = Get.find();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    readLatestMovie();
  }

  //load phim moi
Future<void> readLatestMovie() async {
    try{
      isLoading = true;
      error = "";
      update(['movie']);
      listMovie = await MovieApiService.getLatestMovies();
    } catch (e) {
      error = "Không thể tải danh sách phim";
      print(e);
    } finally {
      isLoading = false;
      update(['movie']);
    }
}

//tim kiem
Future<void> searchMovie(String keyword) async {
  if (keyword
      .trim()
      .isEmpty) {
    await readLatestMovie();
    return;
  }
  try {
    isLoading = true;
    error = "";
    update(['movie']);
    listMovie = await MovieApiService
        .searchMovies(
        keyword.trim()
    );
  } catch (e) {
    error = "Không thể tìm kiếm phim";
    print(e);
  } finally {
    isLoading = false;
    update(['movie']);
  }
}

    //load chi tiet phim

  Future<void> readMovieDetail(String slug) async {
      try{
        isLoading = true;
        error = "";
        update(['detail']);
        movieDetail = await MovieApiService.getMovieDetail(slug);
      } catch (e) {
        error = "Không thể tải chi tiết phim";
        print(e);
      } finally {
        isLoading = false;
        update(['detail']);
      }
  }

    //load theo the loai
  Future<void> readMovieByCategory(String slug) async {
      try{
        isLoading = true;
        error = "";
        update(['movie']);
        listMovie = await MovieApiService.getMoviesByCategory(slug);
      } catch (e) {
        error = "Không thể tải phim theo thể loại";
        print(e);
      } finally {
        isLoading = false;
        update(['movie']);
      }
  }

    //load xem sau
  Future<void> readWatchLater() async {
      try{
        User? user = authController.getCurrentUser();
        if(user == null){
          return;
        }
        isLoading = true;
        update(['watchLater']);
        final data = await supabase
            .from("watch_later")
            .select()
            .eq("user_id", user.id);
        listWatchLater = [];
        for(var item in data) {
          Movie movie = Movie(
              name: item['movie_name'] ?? '',
              slug: item['slug'] ?? '',
              posterUrl: item['poster_url'] ?? '',
              description: '',
              year: item['year'] ?? 0,
              categories: [],
              language: ''
          );

          listWatchLater.add(movie);
        }
      } catch (e) {
        error = "Không thể tải danh sách xem sau";
        print(e);
      } finally {
        isLoading = false;
        update(['watchLater']);
      }
  }

    //them vao xem sau
  Future<bool> addWatchLater() async {
      try{
        User? user = authController.getCurrentUser();
        if(user == null){
          return false;
        }

        if(movieDetail == null){
          return false;
        }
        final data = await supabase
            .from("watch_later")
            .select()
            .eq("user_id", user.id)
            .eq("slug", movieDetail?.slug ?? "");
        if(data.length > 0){
          return false;
        }

        await supabase.
        from("watch_later")
            .insert({
          "user_id": user.id,
          "movie_name": movieDetail?.name ?? "",
          "slug": movieDetail?.slug ?? "",
          "poster_url": movieDetail?.posterUrl ?? "",
          "year": movieDetail?.year ?? 0,
        });

        await readWatchLater();
        return true;
      } catch (e) {
        print(e);
        return false;
      }
  }

    //xoa xem sau
  Future<void> deleteWatchLater(String slug) async {
      try{
        User? user = authController.getCurrentUser();
        if(user == null) {
          return;
        }

        await supabase
            .from("watch_later")
            .delete()
            .eq("user_id", user.id)
            .eq("slug", slug);
        listWatchLater.removeWhere(
          (element) {
            return element.slug == slug;
          },
        );
        update(['watchLater']);
      } catch (e) {
        print(e);
      }
  }
    //kiem tra
  Future<bool> checkWatchLater(String slug) async {
      try{
        User? user = authController.getCurrentUser();
        if(user == null){
          return false;
        }
        
        final data = await supabase
            .from("watch_later")
            .select()
            .eq("user_id", user.id)
            .eq("slug", slug);

        return data.isNotEmpty;
      } catch (e) {
        print(e);
        return false;
      }
  }

}
