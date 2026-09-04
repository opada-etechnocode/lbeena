import '../../../../core/models/base_entity.dart';

abstract class BaseModel {
  const BaseModel();
  BaseEntity toEntity();
}
