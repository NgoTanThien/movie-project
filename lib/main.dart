import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/controllers/movie_controller.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kqsjgfcmailgdlohnnkj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtxc2pnZmNtYWlsZ2Rsb2hubmtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMDE1NjQsImV4cCI6MjA5NDY3NzU2NH0.fjIOqfb01kXrGAno886IsbLAVyNnOt1fdYYh0KhtXAY',
  );

  Get.put(AuthController());
  Get.put(MovieController());

  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng xem phim',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF0F0F0F),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
        ),
      ),
      home: authController.getCurrentUser() != null ? HomeScreen() : LoginScreen(),
    );
  }
}