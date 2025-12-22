/*
 * Book model scaffolded via https://app.quicktype.io/
 */

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userFromJson(String str) => UserModel.fromMap(json.decode(str));
String userToJson(UserModel data) => json.encode(data.toMap());

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phone;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final data = Map<String, dynamic>.from(map);

    DateTime? created;
    DateTime? updated;
    if (data['createdAt'] != null) {
      final v = data['createdAt'];
      if (v is Timestamp) created = v.toDate();
      if (v is String) created = DateTime.tryParse(v);
    }
    if (data['updatedAt'] != null) {
      final v = data['updatedAt'];
      if (v is Timestamp) updated = v.toDate();
      if (v is String) updated = DateTime.tryParse(v);
    }

    return UserModel(
      uid: id ?? data['uid'] ?? data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String?,
      role: data['role'] as String?,
      createdAt: created,
      updatedAt: updated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? phone,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, email: $email)';
}
