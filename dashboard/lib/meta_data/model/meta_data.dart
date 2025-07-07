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
