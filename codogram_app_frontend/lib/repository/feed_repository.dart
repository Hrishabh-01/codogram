import 'package:codogram_app_frontend/model/post_model.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/app_url.dart';

class FeedRepository{
  BaseApiServices _apiServices= NetworkApiServices();
  Future<PostModel> fetchPostFeed ()async{
    try{
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.feedEndPoint);
      return PostModel.fromJson(response);
    }catch(e){
      throw e;
    }
  }
}