// import 'package:json_annotation/json_annotation.dart';
// import '../models/base_entity.dart';
// import 'base_error.dart';
// part 'base_api_error.g.dart';
//
// /// This class represent the Certificate model
// @JsonSerializable()
// class ApiErrorModel extends BaseError {
//   final String? status;
//   final String? message;
//
//   const ApiErrorModel({
//     this.status,
//     this.message,
//   }) : super((message ?? ''));
//
//   factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
//       _$ApiErrorModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
//
//   ApiErrorEntity toEntity() {
//     return ApiErrorEntity();
//   }
// }
//
// class ApiErrorEntity extends BaseEntity {
//   final String? status;
//   final String? message;
//
//   const ApiErrorEntity({
//     this.status,
//     this.message,
//   });
//
//   @override
//   List<Object?> get props => [
//     status,
//         this.message,
//       ];
// }
