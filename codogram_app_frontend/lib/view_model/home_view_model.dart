import 'package:codogram_app_frontend/data/response/api_response.dart';
import 'package:codogram_app_frontend/model/movies_model.dart';
import 'package:codogram_app_frontend/repository/home_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  final _myRepo = HomeRepository();

  ApiResponse<MovieListModel> moviesList = ApiResponse.loading();

  setMoviesList(ApiResponse<MovieListModel> response) {
    moviesList = response;
    notifyListeners();
  }

  Future<void> fetchMoviesListApi() async {
    setMoviesList(ApiResponse.loading());

    _myRepo.fetchMoviesList().then((value) {
      setMoviesList(ApiResponse.completed(value));

    }).onError((error, stackTrace) {
      setMoviesList(ApiResponse.error(error.toString()));
    });
  }
}
