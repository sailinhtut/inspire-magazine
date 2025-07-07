class User {
  int? userId;
  String? email;
  String? name;
  String? profile;
  String? token;

  User({this.userId, this.email, this.name, this.profile, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["id"],
      email: json["email"],
      name: json["name"],
      profile: json["profile"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": userId,
      "email": email,
      "name": name,
      "profile": profile,
      "token": token,
    };
  }

  factory User.sample() {
    return User(
      name: "Inspired User",
      email: "inspired@blog.com",
      profile: null,
      userId: 1,
    );
  }

  User copyWith({
    String? updatedName,
  }) {
    return User(
      userId: userId,
      name: updatedName ?? name,
      email: email,
      profile: profile,
      token: token,
    );
  }
}
