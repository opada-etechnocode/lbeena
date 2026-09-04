class GovernmentWithServicesModel {
  GovernmentWithServicesModel({
    required this.status,
    required this.data,
  });

  final String? status;
  final List<ServiceList> data;

  factory GovernmentWithServicesModel.fromJson(Map<String, dynamic> json){
    return GovernmentWithServicesModel(
      status: json["status"],
      data: json["data"] == null ? [] : List<ServiceList>.from(json["data"]!.map((x) => ServiceList.fromJson(x))),
    );
  }

}

class ServiceList {
  ServiceList({
    required this.id,
    required this.departmentName,
    required this.isActive,
    required this.services,
  });

  final int? id;
  final String? departmentName;
  final int? isActive;
  final List<Service> services;

  factory ServiceList.fromJson(Map<String, dynamic> json){
    return ServiceList(
      id: json["id"],
      departmentName: json["department_name"],
      isActive: json["is_active"],
      services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    );
  }

}

class Service {
  Service({
    required this.id,
    required this.departmentId,
    required this.serviceName,
    required this.description,
    required this.url,
    required this.isActive,
  });

  final int? id;
  final int? departmentId;
  final String? serviceName;
  final String? description;
  final String? url;
  final int? isActive;

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"],
      departmentId: json["department_id"],
      serviceName: json["service_name"],
      description: json["description"],
      url: json["url"],
      isActive: json["is_active"],
    );
  }

}
