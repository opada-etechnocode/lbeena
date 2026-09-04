import 'package:flutter/material.dart';

class AllHashtagModel {
  AllHashtagModel({
    required this.success,
    required this.message,
    required this.hashtag,
    required this.color,
  });

  final bool? success;
  final String? message;
  final List<Hashtag> hashtag;
  final List<ColorsBackground> color;

  factory AllHashtagModel.fromJson(Map<String, dynamic> json){
    return AllHashtagModel(
      success: json["success"],
      message: json["message"],
      hashtag: json["hashtag"] == null ? [] : List<Hashtag>.from(json["hashtag"]!.map((x) => Hashtag.fromJson(x))),
      color: json["colors"] == null ? [] : List<ColorsBackground>.from(json["colors"]!.map((x) => ColorsBackground.fromJson(x))),
    );
  }

}

class ColorsBackground {
  ColorsBackground({
    required this.id,
    required this.color1,
    required this.color2,
    required this.color3,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color1': color1,
      'color2': color2,
      'color3': color3,
    };
  }

  final String? id;
  final String? color1;
  final String? color2;
  final String? color3;

  factory ColorsBackground.fromJson(Map<String, dynamic> json){
    return ColorsBackground(
      id: json["id"],
      color1: json["color1"],
      color2: json["color2"],
      color3: json["color3"],
    );
  }

}

class Hashtag {
  Hashtag({
    required this.id,
    required this.hashtag,
    required this.isImage,
    required this.image,
    required this.color,
    required this.postCount,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hashtag': hashtag,
      'is_image': isImage,
      'image': image,
      'color': color,
      'post_count': postCount,
    };
  }

  final String? id;
  final String? hashtag;
  final String? isImage;
  final String? image;
  final String? color;
  final String? postCount;

  factory Hashtag.fromJson(Map<String, dynamic> json){
    return Hashtag(
      id: json["id"]?.toString(),
      hashtag: json["hashtag"]?.toString(),
      isImage: json["is_image"]?.toString(),
      image: json["image"]?.toString(),
      color: json["color"]?.toString(),
      postCount: json["post_count"]?.toString(),
    );
  }

}
