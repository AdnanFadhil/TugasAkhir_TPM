import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/my_response.dart';
import '../model/user_model.dart';
import 'login_repository.dart';
import 'package:http/http.dart' as http;

class LoginController {
  LoginRepository _repository = LoginRepository();

  bool isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<MyResponse> login() async {
    http.Response result =
        await _repository.login(emailController.text, passwordController.text);

    if (result.statusCode == 200) {
      Map<String, dynamic> myBody = jsonDecode(result.body);
      MyResponse<User> myResponse = MyResponse.fromJson(myBody, User.fromJson);

      debugPrint("${myResponse.message}");

      if (myResponse.code == 0) {
        final prefs = await SharedPreferences.getInstance();
        //simpan token di sharedpreferences
        await prefs.setString('token', myResponse.data?.token ?? "");
      }

      return MyResponse();
    } else {
      return MyResponse(code: 1, message: "Terjadi kesalahan, coba lagi");
    }
  }
}
