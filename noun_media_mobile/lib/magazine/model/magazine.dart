class Magazine {
  int magazineId;
  String? name;
  String? description;
  String? coverPhoto;
  String? advertisementPhoto;
  List<Topic>? topics;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? order;

  Magazine(
      {required this.magazineId,
      this.name,
      this.description,
      this.coverPhoto,
      this.advertisementPhoto,
      this.topics,
      this.order,
      this.createdAt,
      this.updatedAt});

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      magazineId: json["id"],
      name: json["name"],
      description: json["description"],
      advertisementPhoto: json["advertisement_photo"],
      coverPhoto: json["cover_photo"],
      order: json["order"] ?? 0,
      topics: json["topics"] != null
          ? List<dynamic>.from(json["topics"])
              .map((e) => Topic.fromJson(e))
              .toList()
          : [],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }
}

class Topic {
  int topiId;
  String? name;
  String? description;
  String? coverPhoto;
  int? order;

  List<String>? photos;
  DateTime? createdAt;
  DateTime? updatedAt;

  Topic(
      {required this.topiId,
      this.name,
      this.description,
      this.coverPhoto,
      this.photos,
      this.order,
      this.createdAt,
      this.updatedAt});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topiId: json["id"],
      name: json["title"],
      description: json["description"],
      coverPhoto: json["cover_photo"],
      order: json["order"],
      photos: json["content_photos"] != null
          ? List<String>.from(json["content_photos"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }
}
