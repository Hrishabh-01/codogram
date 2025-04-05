import 'package:flutter/material.dart';


class AppUrl {

  static var baseUrl = 'http://192.168.29.221:8000/api/v1';

  static var moviesBaseUrl = 'https://dea91516-1da3-444b-ad94-c6d0c4dfab81.mock.pstmn.io/';

  static var loginPoint = baseUrl + '/users/login';
  static var registerApiEndPoint = baseUrl + '/users/register';

  static var feedEndPoint = baseUrl + '/posts/feed';
  static var myprofileEndPoint = baseUrl + '/users/get-current-user';

  static var moviesListEndPoint = moviesBaseUrl + 'movies_list';
}