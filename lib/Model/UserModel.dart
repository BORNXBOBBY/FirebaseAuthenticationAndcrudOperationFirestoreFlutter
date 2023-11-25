// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  // String image;
  String name;
  String email;
  String address;
  String password;


  UserModel({
    // required this.image,
    required this.name,
    required this.email,
    required this.address,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    // image: json["image"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    // "image": image,
    "name": name,
    "email": email,
    "address": address,
    "password": password,
  };
}
