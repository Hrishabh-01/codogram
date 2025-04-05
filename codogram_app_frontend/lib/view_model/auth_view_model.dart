import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:codogram_app_frontend/repository/auth_repository.dart';
import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/utils/utils.dart';
import 'package:codogram_app_frontend/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class AuthViewModel with ChangeNotifier{
  final _myRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading=false;
  bool get signUpLoading => _signUpLoading;


  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }
  setSignUpLoading(bool value){
    _signUpLoading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data,BuildContext context) async{
    setLoading(true);
    try {
      final value = await _myRepo.loginApi(data);
      setLoading(false);

      // Extract tokens from response
      final responseData = value['data'];
      if (responseData == null) {
        Utils.flushBarErrorMessage("Invalid response from server", context);
        return;
      }
      final accessToken = responseData['accessToken'] ?? '';
      final refreshToken = responseData['refreshToken']?? '';
      final user = responseData['user'];

      // Save tokens in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);

      // Save user details
      final userPreference = Provider.of<UserViewModel>(context, listen: false);
      userPreference.saveUser(UserModel(
        data: Data(
          accessToken: accessToken,
          refreshToken: refreshToken,
          user: User.fromJson(user), // Save user details
        ),
      ));

      Utils.flushBarErrorMessage('Login Successful !!', context);
      Navigator.pushReplacementNamed(context, RoutesName.feed);

      if (kDebugMode) {
        print("User: $user");
      }

      return value; // Returning response for further handling in LoginView
    } catch (error) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) {
        print("Error during API call: $error");
      }
      return null;
    }
  }
  Future<void> signUpApi(dynamic data,BuildContext context) async{
    setSignUpLoading(true);
    try {
      print("SIGNUP DATA: $data");

      final response = await _myRepo.signUpApi(data);
      setSignUpLoading(false);

      // If success, show success message
      Utils.flushBarErrorMessage('Signup Successful !!', context);
      Navigator.pushReplacementNamed(context, RoutesName.home);

      if (kDebugMode) {
        print("Signup response: $response");
      }

    } catch (error) {
      setSignUpLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) {
        print("Signup error: $error");
      }
    }
  }
}