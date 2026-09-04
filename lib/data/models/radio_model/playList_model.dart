class PlayListModel {
  PlayListModel({
    required this.name,
    required this.type,
    required this.source,
    required this.id,
  });

  final String? name;
  final String? type;
  final String? source;
  final int? id;


  factory PlayListModel.fromJson(Map<String, dynamic> json){
    return PlayListModel(
      name: json["name"],
      type: json["type"],
      source: json["source"],
      id: json["id"],
    );
  }


  static List<PlayListModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PlayListModel.fromJson(json)).toList();
  }

}
