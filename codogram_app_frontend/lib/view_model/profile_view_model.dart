import 'package:flutter/material.dart';
import '../data/response/api_response.dart';
import '../model/profile_model.dart';
import '../model/user_model.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _profileRepo = ProfileRepository();

  ApiResponse<ProfileModel> _userProfile = ApiResponse.loading();

  ApiResponse<ProfileModel> get userProfile => _userProfile;

  void _setUserProfile(ApiResponse<ProfileModel> response) {
    _userProfile = response;
    notifyListeners();
  }

  Future<void> fetchCurrentUserProfile() async {
    _setUserProfile(ApiResponse.loading());

    try {
      final user = await _profileRepo.fetchCurrentUser();
      _setUserProfile(ApiResponse.completed(user));
    } catch (error) {
      _setUserProfile(ApiResponse.error(error.toString()));
    }
  }
}
