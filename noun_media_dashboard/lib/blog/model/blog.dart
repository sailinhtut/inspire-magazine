import 'dart:convert';

class Blog {
  int blogId;
  String? name;
  String? description;
  String? content;
  String? writer;
  List<int>? genreIds;
  DateTime? createdAt;
  DateTime? updatedAt;

  Blog(
      {required this.blogId,
      this.name,
      this.description,
      this.content,
      this.writer,
      this.genreIds,
      this.createdAt,
      this.updatedAt});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json["id"],
      name: json["title"],
      description: json["description"],
      content: json["content"],
      writer: json["writer"],
      genreIds: json["genres"] != null
          ? List<int>.from(jsonDecode(json["genres"]))
          : null,
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
      "id": blogId,
      "title": name,
      "description": description ?? "",
      "content": content ?? "-",
      "writer": writer ?? "",
      "genres": genreIds ?? [],
    };
  }

  Blog copyWith({
    String? updatedTitle,
    String? updatedDescription,
    String? updatedContent,
    String? updatedWriter,
    List<int>? updatedGenres,
  }) {
    return Blog(
      blogId: blogId,
      name: updatedTitle ?? name,
      description: updatedDescription ?? description,
      content: updatedContent ?? content,
      writer: updatedWriter ?? writer,
      genreIds: updatedGenres ?? genreIds,
    );
  }
}
