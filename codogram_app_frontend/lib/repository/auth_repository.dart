
import 'package:codogram_app_frontend/data/network/BaseApiServices.dart';
import 'package:codogram_app_frontend/data/network/NetworkApiService.dart';
import 'package:codogram_app_frontend/res/app_url.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthRepository {

  BaseApiServices _apiServices=NetworkApiServices();

  Future<dynamic> loginApi(dynamic data) async {

    try{
      print("Login API Request Data: $data");
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginPoint, data);
      print("Login API Response: $response");
      return response;
    }catch(e){
      // print("Login API Error: $e");
      throw e;
    }
  }
  Future<dynamic> signUpApi(dynamic data) async {

    try{
      dynamic response = await (_apiServices as NetworkApiServices).postMultipartApiResponse(AppUrl.registerApiEndPoint, data);
      return response;
    }catch(e){
      // print("Login API Error: $e");
      throw e;
    }
  }

}