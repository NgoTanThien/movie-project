import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/controllers/movie_controller.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:movie/screens/movie_detail_screen.dart';
import 'package:movie/screens/watch_later_screen.dart';
import 'package:movie/widgets/movie_card.dart';
import 'package:movie/widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final MovieController movieController = Get.find<MovieController>();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                searchController.clear();
                await movieController.readLatestMovie();
              },
              child: Image.asset("assets/icons/logo.png", width: 200,),
            ),
          ],
        )
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red
                ),
                accountName: Text(
                  "Xin chào",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                accountEmail: Text(
                  authController.getCurrentUser()?.email ?? "Người dùng",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
            ListTile(
              title: Text("Trang Chủ"),
              onTap: () async {
                Navigator.of(context).pop();
                searchController.clear();
                await movieController.readLatestMovie();
              },
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
            ),
            Divider(thickness: 0.5,),
            ListTile(
              title: Text("Xem Sau"),
              onTap: () {
                Get.to(
                        () => WatchLaterScreen()
                );
              },
              leading: Icon(
                Icons.bookmark,
                color: Colors.grey,
              ),
            ),
            Divider(thickness: 2,),
            ListTile(
              title: Text("Đăng Xuất", style: TextStyle(color: Colors.red),),
              onTap: logout,
              leading: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16
              ),
            child: SearchBarWidget(
                controller: searchController,
                onVoidSearch: () async {
                  await movieController.readLatestMovie();
                },
                onSearch: movieController.searchMovie,
            ),
          ),
          SizedBox(height: 16,),
          SizedBox(
            height: 45,
            child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: 16
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2A2A2A)
                          ),
                          onPressed: () {
                            movieController.readMovieByCategory(
                              category['slug']!
                            );
                          },
                          child: Text(
                            category['name']!,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                      ),
                  );
                },
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
              child: GetBuilder<MovieController>(
                  id: "movie",
                  builder: (controller) {
                    if(controller.isLoading){
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }

                    if(controller.listMovie.isEmpty){
                      return Center(
                        child: Text(
                          "Không có phim nào",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      );
                    }
                    
                    return Expanded( 
                      child: GridView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: controller.listMovie.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.58,
                          ),
                          itemBuilder: (context, index) {
                            final movie = controller.listMovie[index];
                            return MovieCard(
                                movie: movie,
                                onTap: () {
                                  openMovieDetail(movie);
                                },
                            );
                          },
                      ),
                    );
                  },
              )
          )
        ],
      ),
    );
  }

  final List<Map<String, String>> categories = [
    {
      "name" : "Hành động",
      "slug" : "hanh-dong"
    },
    {
      "name" : "Hài hước",
      "slug" : "hai-huoc"
    },
    {
      "name" : "Kinh dị",
      "slug" : "kinh-di"
    },
    {
      "name" : "Tâm lý",
      "slug" : "tam-ly"
    },
    {
      "name" : "Tình cảm",
      "slug" : "tinh-cam"
    },
    {
      "name" : "Trinh thám",
      "slug" : "trinh-tham"
    },
    {
      "name" : "Viễn tưởng",
      "slug" : "vien-tuong"
    },
    {
      "name" : "Hài kịch",
      "slug" : "hai-kich"
    },
    {
      "name" : "Hoạt hình",
      "slug" : "hoat-hinh"
    }
  ];

  void openMovieDetail(Movie movie){
    Get.to(
      () => MovieDetailScreen(
        movie: movie,
      ),
    );
  }

  Future<void> logout() async{
    await authController.logout(); 
    Get.offAll(
      () => LoginScreen(),
    );
  }
  
  @override
  void initState() {
    super.initState();
    movieController.readLatestMovie();
  }
}
