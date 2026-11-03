import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/controllers/movie_controller.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_detail.dart';
import 'package:movie/screens/video_player_screen.dart';
import 'package:movie/widgets/category_chip.dart';
import 'package:movie/widgets/movie_info_chip.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieController movieController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<MovieController>(
          id: "detail",
          builder: (controller) {
            if(controller.isLoading){
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if(controller.movieDetail == null){
              return Center(
                child: Text(
                  "Không thể tải phim",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              );
            }
            MovieDetail movieDetail = controller.movieDetail!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        widget.movie.posterUrl,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                          top: 40,
                          left: 10,
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                              )
                          )
                      ),
                      Positioned(
                          top: 40,
                          right: 10,
                          child: IconButton(
                              onPressed: addWatchLater, 
                              icon: Icon(
                                Icons.bookmark,
                                color: Colors.yellow,
                                size: 30,
                              )
                          )
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            movieDetail.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 16,),
                          Row(
                            children: [
                              MovieInfoChip(
                                  text: "${movieDetail.year}"
                              ),
                              SizedBox(width: 12),
                              MovieInfoChip(
                                  text: movieDetail.quality
                              ),
                              SizedBox(width: 12),
                              MovieInfoChip(
                                  text: movieDetail.language
                              )
                            ],
                          ),
                          SizedBox(height: 16,),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            crossAxisAlignment: .start,
                            children: movieDetail.categories.map((category) {
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: CategoryChip(
                                      category: category
                                  ),
                              );
                            },
                            ).toList()
                          ),
                          SizedBox(height: 20,),
                          Text(
                            "Mô tả",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            movieDetail.description,
                            style: TextStyle(
                              color: Colors.grey,
                              height: 1.5
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Đạo diễn",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movieDetail.director.isNotEmpty ? movieDetail.director : "Đang cập nhật",
                            style: TextStyle(
                                color: Colors.grey,
                                height: 1.5
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Diễn viên",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movieDetail.actors.isNotEmpty ? movieDetail.actors.join(", ") : "Đang cập nhật",
                            style: TextStyle(
                                color: Colors.grey,
                                height: 1.5
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Quốc gia",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movieDetail.country.isNotEmpty ? movieDetail.country : "Đang cập nhật",
                            style: TextStyle(
                                color: Colors.grey,
                                height: 1.5
                            ),
                          ),
                          SizedBox(height: 25,),
                          Text(
                            "Danh sách tập",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: movieDetail.episodes.first.serverData.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.7,
                            ),
                            itemBuilder: (context, index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A1A1A),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  watchMovie(movieDetail, index);
                                },
                                child: Text(
                                  "Tập ${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red
                                ),
                                onPressed: () {
                                  watchMovie(
                                      movieDetail,
                                      0
                                  );
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Xem ngay",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                            ),
                          )
                        ],
                      ),
                  )
                ],
              ),
            );
          },
      ),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieController.readMovieDetail(widget.movie.slug);
  }
  
  Future<void> addWatchLater() async{
    if(authController.getCurrentUser() == null){
      Get.snackbar(
          "Thông báo",
          "Vui lòng đăng nhập",
          backgroundColor: Colors.orange,
          colorText: Colors.white
      );
      return;
    }

    bool isAdd = await movieController.addWatchLater();

    if(isAdd){
      Get.snackbar(
      "Thông báo",
      "Đã thêm vào xem sau",
       backgroundColor: Colors.green,
       colorText: Colors.white
      );
    } else {
      Get.snackbar(
      "Thông báo",
      "Phim đã tồn tại",
       backgroundColor: Colors.orange,
       colorText: Colors.white
      );
    }
  }

  void watchMovie(MovieDetail movieDetail, int index){
    Get.to(
        () => VideoPlayerScreen(
            movieDetail: movieDetail,
            initialEpisodeIndex: index,
        )
    );
  }
}
