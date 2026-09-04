import 'package:syrians_in_uae/data/models/news/news_model.dart';

class NewItemModel {
  NewItemModel({
    required this.status,
    required this.massage,
    required this.news,
  });

  final bool? status;
  final String? massage;
  final List<NewsList> news;

  factory NewItemModel.fromJson(Map<String, dynamic> json){
    return NewItemModel(
      status: json["status"],
      massage: json["massage"],
      news: json["news"] == null ? [] : List<NewsList>.from(json["news"]!.map((x) => NewsList.fromJson(x))),
    );
  }

}
