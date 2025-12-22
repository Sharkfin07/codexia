/*
 * Book model scaffolded via https://app.quicktype.io/
 */

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String uid;
  String name;
  String email;

  UserModel({required this.uid, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(uid: json["uid"], name: json["name"], email: json["email"]);

  Map<String, dynamic> toJson() => {"uid": uid, "name": name, "email": email};
}
