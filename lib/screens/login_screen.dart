import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/screens/home_screen.dart';
import 'package:movie/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              _buildHeader(),
              SizedBox(height: 30,),
              _buildEmailField(),
              SizedBox(height: 20,),
              _buildPasswordField(),
              SizedBox(height: 30,),
              _buildLoginButton(),
              SizedBox(height: 20,),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async{
    bool isLogin = await authController.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );

    if(isLogin){
      Get.offAll(
        () => HomeScreen(),
      );
    } else {
      Get.snackbar(
          "Thông báo",
          authController.error,
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
    }
  }

  Widget _buildHeader(){
    return Column(
      children: [
        Icon(
            Icons.movie,
            color: Colors.red,
            size: 90,
        ),
        SizedBox(height: 20,),
        Text(
          "Đăng nhập",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }

  Widget _buildEmailField(){
    return TextField(
      controller: emailController,
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(
          color: Colors.grey
        ),
        filled: true,
        fillColor: Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        )
      ),
    );
  }

  Widget _buildPasswordField(){
    return TextField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        hintText: "Mật khẩu",
        hintStyle: TextStyle(
          color: Colors.grey
        ),
        filled: true,
        fillColor: Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        )
      ),
    );
  }

  Widget _buildLoginButton(){
    return GetBuilder<AuthController>(
        id: "auth",
        builder: (controller) {
          return SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                onPressed: controller.isLoading ? null : login,
                child: controller.isLoading ? CircularProgressIndicator(
                  color: Colors.white,
                ) : Text(
                  "Đăng nhập",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                )
            ),
          );
        },
    );
  }

  Widget _buildRegisterButton(){
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text(
            "Bạn chưa có tài khoản?",
            style: TextStyle(
                color: Colors.white
            ),
        ),
        TextButton(
            onPressed: () {
              Get.to(
                  () => RegisterScreen()
              );
            },
            child: Text(
              "Đăng ký",
              style: TextStyle(color: Colors.red),
            )
        )
      ],
    );
  }
}
