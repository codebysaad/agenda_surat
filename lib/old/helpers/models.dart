import 'dart:convert';

import 'package:flutter/material.dart';

Models userModelFromJson(String str) => Models.fromJson(json.decode(str));

String userModelToJson(Models data) => json.encode(data.toJson());

class Models {
  String statusCode;
  String message;
  String email;
  String nama;
  String password;

  Models({@required this.statusCode, this.message, this.email, this.nama, this.password});

  factory Models.fromJson(Map<String, dynamic> json) => Models(
    statusCode: json["statusCode"],
    message: json["message"],
    email: json["email"],
    password: json["password"],
    nama: json["nama"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "email": email,
    "password": password,
    "nama": nama,
  };
}