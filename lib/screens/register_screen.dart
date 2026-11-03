import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:movie/screens/verify_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conFirmPasswordController = TextEditingController();
  final AuthController authController = Get.find();

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
              SizedBox(height: 20,),
              _buildConfirmPasswordField(),
              SizedBox(height: 30,),
              _buildRegisterButton(),
              SizedBox(height: 20,),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async{
    if(
    emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        conFirmPasswordController.text.trim().isEmpty
    ){
      Get.snackbar(
        "Thông báo",
        "Vui lòng nhập đầy đủ thông tin",
        backgroundColor: Colors.red,
        colorText: Colors.white
      );

      return;
    }
    if(passwordController.text != conFirmPasswordController.text){
      Get.snackbar(
          "Thông báo",
          "Mật khẩu không khớp",
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
      return;
    }

    bool isRegister = await authController.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );

    if(isRegister){
      Get.to(
          () => VerifyOtpScreen(),
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
            Icons.person_add,
            color: Colors.red,
            size: 90,
        ),
        SizedBox(height: 10,),
        Text(
          "Đăng ký",
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

  Widget _buildConfirmPasswordField(){
    return TextField(
      controller: conFirmPasswordController,
      obscureText: true,
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        hintText: "Nhập lại mật khẩu",
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

  Widget _buildRegisterButton(){
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
                onPressed: controller.isLoading ? null : register,
                child: controller.isLoading ? CircularProgressIndicator(
                  color: Colors.white,
                ) : Text(
                  "Đăng ký",
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

  Widget _buildLoginButton(){
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text(
          "Đã có tài khoản?",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        TextButton(
            onPressed: () {
              Get.off(
                  () => LoginScreen(),
              );
            }, 
            child: Text(
              "Đăng nhập",
              style: TextStyle(
                color: Colors.red
              ),
            )
        )
      ],
    );
  }
}
