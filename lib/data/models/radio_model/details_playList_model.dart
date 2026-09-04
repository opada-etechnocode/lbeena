  class DetailsPlayListModel {
  DetailsPlayListModel({
    required this.spmId,
    required this.mediaId,
    required this.songId,
    required this.artist,
    required this.title,
  });

  final int? spmId;
  final String? mediaId;
  final String? songId;
  final String? artist;
  final String? title;

  factory DetailsPlayListModel.fromJson(Map<String, dynamic> json){
    return DetailsPlayListModel(
      spmId: json["spm_id"],
      mediaId:"https://a8.asurahosting.com/api/station/420/file/${json["media_id"].toString()}/play",
      songId: json["song_id"],
      artist: json["artist"],
      title: json["title"],
    );
  }

  static List<DetailsPlayListModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DetailsPlayListModel.fromJson(json)).toList();
  }
}

//https://a8.asurahosting.com/api/station/420/file/{media_id}/play