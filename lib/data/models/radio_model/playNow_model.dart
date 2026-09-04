class PlayNowModel {
  PlayNowModel({
    required this.nowPlaying,
  });

  final NowPlaying? nowPlaying;

  factory PlayNowModel.fromJson(Map<String, dynamic> json){
    return PlayNowModel(
      nowPlaying: json["now_playing"] == null ? null : NowPlaying.fromJson(json["now_playing"]),
    );
  }

}

class NowPlaying {
  NowPlaying({
    required this.shId,
    required this.playedAt,
    required this.duration,
    required this.playlist,
    required this.streamer,
    required this.isRequest,
    required this.song,
    required this.elapsed,
    required this.remaining,
  });

  final int? shId;
  final int? playedAt;
  final int? duration;
  final String? playlist;
  final String? streamer;
  final bool? isRequest;
  final Song? song;
  final int? elapsed;
  final int? remaining;

  factory NowPlaying.fromJson(Map<String, dynamic> json){
    return NowPlaying(
      shId: json["sh_id"],
      playedAt: json["played_at"],
      duration: json["duration"],
      playlist: json["playlist"],
      streamer: json["streamer"],
      isRequest: json["is_request"],
      song: json["song"] == null ? null : Song.fromJson(json["song"]),
      elapsed: json["elapsed"],
      remaining: json["remaining"],
    );
  }

}

class Song {
  Song({
    required this.id,
    required this.art,
    required this.customFields,
    required this.text,
    required this.artist,
    required this.title,
    required this.album,
    required this.genre,
    required this.isrc,
    required this.lyrics,
  });

  final String? id;
  final String? art;
  final List<dynamic> customFields;
  final String? text;
  final String? artist;
  final String? title;
  final String? album;
  final String? genre;
  final String? isrc;
  final String? lyrics;

  factory Song.fromJson(Map<String, dynamic> json){
    return Song(
      id: json["id"],
      art: json["art"],
      customFields: json["custom_fields"] == null ? [] : List<dynamic>.from(json["custom_fields"]!.map((x) => x)),
      text: json["text"],
      artist: json["artist"],
      title: json["title"],
      album: json["album"],
      genre: json["genre"],
      isrc: json["isrc"],
      lyrics: json["lyrics"],
    );
  }

}
