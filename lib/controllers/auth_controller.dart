import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  String error = "";
  String email = "";

  final SupabaseClient supabase = Supabase.instance.client;

  User? getCurrentUser(){
    return supabase.auth.currentUser;
  }

  //Dang ky

  Future<bool> register({required String email, required String password}) async{
    try{
      isLoading = true;
      error = "";
      update(['auth']);
      await supabase.auth.signUp(
          email: email,
          password: password
      );
      this.email = email;
      return true;
    } catch (e) {
      error = "Đăng ký thất bại";
      print(e);
      return false;
    } finally {
      isLoading = false;
      update(['auth']);
    }
  }

  //xac thuc

  Future<bool> verifyOTP(String otp) async{
    try{
      isLoading = true;
      error = "";
      update(['auth']);
      await supabase.auth.verifyOTP(
          email: email,
          token: otp,
          type: OtpType.signup
      );
      return true;
    } catch (e) {
      error = "Mã OTP không hợp lệ";
      print(e);
      return false;
    } finally {
      isLoading = false;
      update(['auth']);
    }
}

//dang nhap

  Future<bool> login({required String email, required String password}) async{
    try{
      isLoading = true;
      error = "";
      update(['auth']);
      await supabase.auth.signInWithPassword(
          email: email,
          password: password
      );
      return true;
    } catch (e) {
      error = "Email hoặc mật khẩu không đúng";
      print(e);
      return false;
    } finally {
      isLoading = false;
      update(['auth']);
    }
}

//dang xuat
Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
