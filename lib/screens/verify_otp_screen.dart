import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/controllers/auth_controller.dart';
import 'package:movie/screens/home_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                  Icons.email,
                  color: Colors.red,
                  size: 90,
              ),
              SizedBox(height: 20,),
              Text(
                "Nhập mã OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: otpController,
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                  hintText: "Mã OTP",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                  )
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                    ),
                    onPressed: verifyOTP,
                    child: Text(
                      "Xác thực",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTP() async{
    bool isVerify = await authController.verifyOTP(
      otpController.text.trim()
    );

    if(isVerify){
      Get.offAll(
        () => HomeScreen(),
      );
    } else {
      Get.snackbar(
        "Thông báo",
        authController.error,
      );
    }
  }
}
