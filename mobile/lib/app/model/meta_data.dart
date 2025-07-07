// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class MetaDataTypes {
  static get pravicy_policy => "pravicy-policy";
  static get terms => "terms";
  static get about_us => "about-us";
}

class NounMetaData {
  int? id;
  String? name;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;

  NounMetaData({
    this.id,
    this.name,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory NounMetaData.fromJson(Map<dynamic, dynamic> json) {
    final image = NounMetaData(
      id: json["id"],
      name: json["name"],
      content: json["content"],
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
    );

    return image;
  }
}
