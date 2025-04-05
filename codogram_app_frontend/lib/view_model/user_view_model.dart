import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';


class UserViewModel with ChangeNotifier{
  Future<bool> saveUser(UserModel user)async{

    final SharedPreferences sp=await SharedPreferences.getInstance();
    await sp.setString('accessToken', user.data!.accessToken.toString());
    await sp.setString('refreshToken', user.data!.refreshToken.toString());
    notifyListeners();
    return true;
  }
  Future<UserModel>getUser()async{

    final SharedPreferences sp=await SharedPreferences.getInstance();
    final String? accessToken = sp.getString('accessToken');
    final String? refreshToken = sp.getString('refreshToken');
    return UserModel(
      data: Data(
        accessToken: accessToken ?? '',
        refreshToken: refreshToken ?? '',
      ),
    );
  }
  Future<bool> remove()async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('accessToken');
    await sp.remove('refreshToken'); // Remove refreshToken
    notifyListeners();
    return true;
  }
}