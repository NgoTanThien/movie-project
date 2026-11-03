import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controllers/movie_controller.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/screens/movie_detail_screen.dart';
import 'package:movie/widgets/movie_card.dart';

class WatchLaterScreen extends StatefulWidget {
  WatchLaterScreen({super.key});

  @override
  State<WatchLaterScreen> createState() => _WatchLaterScreenState();
}

class _WatchLaterScreenState extends State<WatchLaterScreen> {
  final MovieController movieController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Danh Sách Xem Sau",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: GetBuilder<MovieController>(
          id: "watchLater",
          builder: (controller) {
            if(controller.isLoading){
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if(controller.listWatchLater.isEmpty){
              return Center(
                child: Text(
                  "Chưa có phim nào trong xem sau",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: controller.listWatchLater.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                final movie = controller.listWatchLater[index];
                return Stack(
                  children: [
                    Positioned.fill(
                      child: MovieCard(
                        movie: movie,
                        onTap: () {
                          openMovieDetail(movie);
                        },
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        child: IconButton(
                          padding: EdgeInsets.all(8),
                          onPressed: () {
                            deleteMovie(movie.slug);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieController.readWatchLater();
  }

  void openMovieDetail(Movie movie){
    Get.to(
      () => MovieDetailScreen(
        movie: movie,
      ),
    );
  }

  Future<void> deleteMovie(String slug) async {
    await movieController.deleteWatchLater(
      slug
    );
    Get.snackbar(
    "Thông báo",
    "Đã xóa khỏi xem sau",
     backgroundColor: Colors.red,
     colorText: Colors.white
    );
  }
}
