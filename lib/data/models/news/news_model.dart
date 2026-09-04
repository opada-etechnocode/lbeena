class NewsModel {
  NewsModel({
    required this.status,
    required this.message,
    required this.news,
  });

  final bool? status;
  final String? message;
  final News? news;

  factory NewsModel.fromJson(Map<String, dynamic> json){
    return NewsModel(
      status: json["status"],
      message: json["message"],
      news: json["news"] == null ? null : News.fromJson(json["news"]),
    );
  }

}

class News {
  News({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<NewsList> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory News.fromJson(Map<String, dynamic> json){
    return News(
      currentPage: json["current_page"],
      data: json["data"] == null ? [] : List<NewsList>.from(json["data"]!.map((x) => NewsList.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

}

class NewsList {
  NewsList({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.sortOrder,
    required this.createdAt,
    required this.link,
    required this.source,
    required this.image,
    required this.id,
    required this.isTape,
  });

  final String? title;
  final String? description;
  final String? backgroundColor;
  final int? sortOrder;
  final DateTime? createdAt;
  final String? link;
  final String? source;
  final String? image;
  final int? id;
  final int? isTape;

  factory NewsList.fromJson(Map<String, dynamic> json){
    return NewsList(
      title: json["title"]?.toString(),
      description: json["description"]?.toString(),
      backgroundColor: json["background_color"]?.toString(),
      sortOrder: json["sort_order"],
      createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ""),
      link: json["link"]?.toString(),
      source: json["source"]?.toString(),
      image: json["Image"]?.toString(),
      id: json["id"],
      isTape: json["is_tape"],
    );
  }

}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"]?.toString(),
      label: json["label"]?.toString(),
      active: json["active"],
    );
  }

}
