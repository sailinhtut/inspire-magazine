class Genre {
  int genreId;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Genre(
      {required this.genreId,
      this.name,
      this.description,
      this.createdAt,
      this.updatedAt});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      genreId: json["id"],
      name: json["name"],
      description: json["description"],
     createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": genreId,
      "name": name,
      "description": description,
    };
  }

  Genre copyWith({
    String? updatedName,
    String? updatedDescription,
  }) {
    return Genre(
      genreId: genreId,
      name: updatedName ?? name,
      description: updatedDescription ?? description,
    );
  }
}
