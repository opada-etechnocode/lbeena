class AppTermsPolicyLinksModel {
  AppTermsPolicyLinksModel({
    required this.status,
    required this.message,
    required this.dataAppTermsPolicyLinks,
  });

  final String? status;
  final String? message;
  final DataAppTermsPolicyLinks? dataAppTermsPolicyLinks;

  factory AppTermsPolicyLinksModel.fromJson(Map<String, dynamic> json){
    return AppTermsPolicyLinksModel(
      status: json["status"],
      message: json["message"],
      dataAppTermsPolicyLinks: json["DataAppTermsPolicyLinks"] == null ? null : DataAppTermsPolicyLinks.fromJson(json["DataAppTermsPolicyLinks"]),
    );
  }

}

class DataAppTermsPolicyLinks {
  DataAppTermsPolicyLinks({
    required this.app,
    required this.terms,
    required this.policy,
    required this.faq,
    required this.safety,
  });

  final String? app;
  final String? terms;
  final String? policy;
  final String? safety;
  final String? faq;

  factory DataAppTermsPolicyLinks.fromJson(Map<String, dynamic> json){
    return DataAppTermsPolicyLinks(
      app: json["app"]?.toString(),
      terms: json["terms"]?.toString(),
      policy: json["policy"]?.toString(),
      safety: json["safety"]?.toString(),
      faq: json["faq"]?.toString(),
    );
  }

}
