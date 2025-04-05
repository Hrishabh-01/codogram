
import 'package:codogram_app_frontend/model/profile_model.dart';
import 'package:codogram_app_frontend/res/app_url.dart';

import '../data/network/NetworkApiService.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final NetworkApiServices _apiService = NetworkApiServices();

  Future<ProfileModel> fetchCurrentUser() async {
    try {
      dynamic response = await _apiService.getGetApiResponse(AppUrl.myprofileEndPoint);
      return ProfileModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
