import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:codogram_app_frontend/model/user_model.dart';
import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/view_model/user_view_model.dart';

class SplashServices {
  Future<UserModel> getUserData() => UserViewModel().getUser();
  void checkAuthentication(BuildContext context) async {
    try {
      final value = await getUserData();

      final accessToken =
          value.data?.accessToken ?? ''; // Handle null case safely
      print("Access Token: $accessToken");

      await Future.delayed(Duration(seconds: 3)); // Smooth splash transition

      if (accessToken.isEmpty ||_isTokenExpired(accessToken)) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.intro);
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching user data: $error");
      }
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      final exp = payload['exp'];
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print("Token decode error: $e");
      return true;
    }
  }
}
