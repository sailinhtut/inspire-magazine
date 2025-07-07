class Advertisement {
  int? id;
  String? name;
  String? description;
  String? redirect;
  String? imageUrl;
  AdsTypes? adsType;

  DateTime? createdAt;
  DateTime? updatedAt;

  Advertisement({
    this.id,
    this.name,
    this.description,
    this.redirect,
    this.imageUrl,
    this.adsType,
    this.createdAt,
    this.updatedAt,
  });

  factory Advertisement.fromJson(Map<dynamic, dynamic> json) {
    final image = Advertisement(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      redirect: json["redirect"],
      imageUrl: json["image_url"],
      adsType: parseAdsType(json["ads_type"]),
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
    );

    return image;
  }

  bool get isWebUrl =>
      redirect != null &&
      (redirect!.startsWith("https://") || redirect!.startsWith("http://"));
}

enum AdsTypes {
  magazine,
  entertainment,
  popup,
}

AdsTypes parseAdsType(String key) {
  switch (key) {
    case "magazine":
      return AdsTypes.magazine;
    case "entertainment":
      return AdsTypes.entertainment;
    case "popup":
      return AdsTypes.popup;
    default:
      return AdsTypes.magazine;
  }
}
