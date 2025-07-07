class HeaderImage {
  int? id;
  String? name;
  String? redirect;
  int? order;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  HeaderImage({
    this.id,
    this.name,
    this.redirect,
    this.order,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory HeaderImage.fromJson(Map<dynamic, dynamic> json) {
    final image = HeaderImage(
      id: json["id"],
      name: json["name"],
      redirect: json["redirect"],
      imageUrl: json["image_url"],
      order: int.tryParse(json["order"].toString()) ?? 0,
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
    );

    return image;
  }

  bool get isWebUrl =>
      redirect != null &&
      (redirect!.startsWith("https://") || redirect!.startsWith("http://"));
}
