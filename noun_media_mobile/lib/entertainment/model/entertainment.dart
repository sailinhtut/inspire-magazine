class Entertainment {
  int? id;
  String? name;
  String? description;
  String? coverPhoto;
  List<Series>? series;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;

  Entertainment({
    this.id,
    this.name,
    this.description,
    this.coverPhoto,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.series,
  });

  factory Entertainment.fromJson(Map<dynamic, dynamic> json) {
    final entertainment = Entertainment(
      id: json["id"],
      name: json["name"],
      order: json["order"] ?? 0,
      description: json["description"],
      coverPhoto: json["cover_photo"],
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
    );

    final seriesJson = List<dynamic>.from(json["series"] ?? []);
    entertainment.series = seriesJson.map((e) => Series.fromJson(e)).toList();

    return entertainment;
  }
}

class Series {
  int? id;
  int? entertainmentId;
  String? name;
  String? description;
  String? coverPhoto;
  int? order;
  List<Episode>? episodes;
  DateTime? createdAt;
  DateTime? updatedAt;

  Series({
    this.id,
    this.entertainmentId,
    this.name,
    this.description,
    this.coverPhoto,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.episodes,
  });

  factory Series.fromJson(Map<dynamic, dynamic> json) {
    final series = Series(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      coverPhoto: json["cover_photo"],
      order: json["order"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
    );

    final episodesJson = List<dynamic>.from(json["episodes"] ?? []);
    series.episodes = episodesJson.map((e) => Episode.fromJson(e)).toList();

    return series;
  }
}

class Episode {
  int? id;
  int? seriesId;
  String? title;
  String? description;
  String? videoThumbnail;
  String? videoUrl;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;

  Episode({
    this.id,
    this.title,
    this.description,
    this.videoUrl,
    this.videoThumbnail,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory Episode.fromJson(Map<dynamic, dynamic> json) {
    final episode = Episode(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      videoUrl: json["video_url"],
      order: json["order"] ?? 0,
      videoThumbnail: json["video_thumbnail"],
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
    );

    return episode;
  }
}
