class UserModel {
  late String name;
  late String about;
  late String email;
  late String id;
  late String image;
  late String createdAt;
  late String pushToken;
  late bool isOnline;
  late String lastActive;

  UserModel({
    required this.name,
    required this.about,
    required this.email,
    required this.id,
    required this.image,
    required this.createdAt,
    required this.pushToken,
    required this.isOnline,
    required this.lastActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        about: json['about'],
        email: json['emial'] ?? '',
        id: json['id'] ?? '',
        image: json['image'] ?? '',
        createdAt: json['createdAt'] ?? '',
        pushToken: json['pushToken'] ?? '',
        isOnline: json['isOnline'] ?? '',
        lastActive: json['lastActive'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'about': about,
        'emial': email,
        'createdAt': createdAt,
        'pushToken': pushToken,
        'isOnline': isOnline,
        'lastActive': lastActive,
      };
}
