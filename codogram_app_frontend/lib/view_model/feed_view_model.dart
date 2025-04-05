import 'package:codogram_app_frontend/repository/feed_repository.dart';
import 'package:flutter/cupertino.dart';

import '../data/response/api_response.dart';
import '../model/post_model.dart';

class FeedViewModel with ChangeNotifier{
  final _feedRepo =FeedRepository();

  ApiResponse<PostModel> postFeed = ApiResponse.loading();
// Setter for updating the post feed state and notifying UI
  void setPostFeed(ApiResponse<PostModel> response) {
    postFeed = response;
    notifyListeners();
  }

  // Function to fetch feed from the repository
  Future<void> fetchPostFeed() async {
    setPostFeed(ApiResponse.loading());

    try {
      final response = await _feedRepo.fetchPostFeed();
      setPostFeed(ApiResponse.completed(response));
    } catch (error) {
      setPostFeed(ApiResponse.error(error.toString()));
    }
  }



}