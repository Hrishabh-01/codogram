import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:codogram_app_frontend/data/app_exceptions.dart';
import 'package:codogram_app_frontend/data/network/BaseApiServices.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:codogram_app_frontend/res/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');
      print("Token used for GET request: $token");
      final response =
      await http.get(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
      ).timeout(const Duration(seconds: 10));
      responseJson=returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url,dynamic data) async{
    dynamic responseJson;
    try {
      Response response=await post(
          Uri.parse(url),
          body:data
      ).timeout(Duration(seconds: 10));
      responseJson=returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorizedException(response.body.toString());
      case 404:
        throw BadRequestException(response.body.toString());
      case 500:
        throw UnauthorizedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communicating with server' +
                'with status code' +
                response.statusCode.toString());
    }
  }
  Future<dynamic> postMultipartApiResponse(String url, Map<String, dynamic> data) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add normal fields
      data.forEach((key, value) {
        if (key != 'avatar' && key != 'coverImage' && value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add avatar image (required)
      if (data['avatar'] != null && data['avatar'] is String) {
        final avatarPath = data['avatar'];
        final mimeType = lookupMimeType(avatarPath);
        final file = await http.MultipartFile.fromPath(
          'avatar',
          avatarPath,
          contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
        );
        request.files.add(file);
      }

      // Add cover image (optional)
      if (data['coverImage'] != null && data['coverImage'] is String) {
        final coverPath = data['coverImage'];
        final mimeType = lookupMimeType(coverPath);
        final file = await http.MultipartFile.fromPath(
          'coverImage',
          coverPath,
          contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
        );
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      final response = http.Response(responseBody, streamedResponse.statusCode);

      return returnResponse(response); // same as your existing handler
    } catch (e) {
      throw FetchDataException('Multipart Upload Failed: $e');
    }
  }
}
