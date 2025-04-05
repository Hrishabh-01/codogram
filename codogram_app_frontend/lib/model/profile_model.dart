class ProfileModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  ProfileModel({this.statusCode, this.data, this.message, this.success});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String? sId;
  String? username;
  String? email;
  String? avatar;
  String? coverImage;
  String? bio;
  List<String>? skills;
  String? createdAt;
  List<Posts>? posts;
  int? followersCount;
  int? followingCount;
  int? postsCount;

  Data(
      {this.sId,
        this.username,
        this.email,
        this.avatar,
        this.coverImage,
        this.bio,
        this.skills,
        this.createdAt,
        this.posts,
        this.followersCount,
        this.followingCount,
        this.postsCount});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    avatar = json['avatar'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    skills = json['skills'].cast<String>();
    createdAt = json['createdAt'];
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    postsCount = json['postsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['coverImage'] = this.coverImage;
    data['bio'] = this.bio;
    data['skills'] = this.skills;
    data['createdAt'] = this.createdAt;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    data['followersCount'] = this.followersCount;
    data['followingCount'] = this.followingCount;
    data['postsCount'] = this.postsCount;
    return data;
  }
}

class Posts {
  String? sId;
  List<String>? media;
  String? createdAt;
  int? commentsCount;

  Posts({this.sId, this.media, this.createdAt, this.commentsCount});

  Posts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    media = json['media'].cast<String>();
    createdAt = json['createdAt'];
    commentsCount = json['commentsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['media'] = this.media;
    data['createdAt'] = this.createdAt;
    data['commentsCount'] = this.commentsCount;
    return data;
  }
}
