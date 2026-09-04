class HasFavoritesModel {
  HasFavoritesModel({
    required this.status,
    required this.hasFavorites,
  });

  final String? status;
  final int? hasFavorites;

  factory HasFavoritesModel.fromJson(Map<String, dynamic> json){
    return HasFavoritesModel(
      status: json["status"],
      hasFavorites: json["has_favorites"],
    );
  }

}
