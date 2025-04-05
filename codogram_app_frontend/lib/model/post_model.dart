class PostModel {
  int? statusCode;
  List<Data>? data;
  String? message;
  bool? success;

  PostModel({this.statusCode, this.data, this.message, this.success});

  PostModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String? sId;
  User? user;
  String? title;
  String? description;
  List<String>? media;
  List<String>? tags;
  bool? isPublic;
  String? createdAt;

  Data(
      {this.sId,
        this.user,
        this.title,
        this.description,
        this.media,
        this.tags,
        this.isPublic,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    title = json['title'];
    description = json['description'];
    media = json['media'].cast<String>();
    tags = json['tags'].cast<String>();
    isPublic = json['isPublic'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['media'] = this.media;
    data['tags'] = this.tags;
    data['isPublic'] = this.isPublic;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class User {
  String? sId;
  String? username;
  String? avatar;

  User({this.sId, this.username, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    return data;
  }
}
