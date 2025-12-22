/*
 * Book model scaffolded via https://app.quicktype.io/
 */

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String userId;
  String name;
  String email;

  UserModel({required this.userId, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(userId: json["uid"], name: json["name"], email: json["email"]);

  Map<String, dynamic> toJson() => {
    "uid": userId,
    "name": name,
    "email": email,
  };
}
