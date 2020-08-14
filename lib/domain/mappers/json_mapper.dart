abstract class JsonMapper {
  Map<String, dynamic> toJson(dynamic clazz);
  dynamic fromJson(Map<String, dynamic> json);
}
