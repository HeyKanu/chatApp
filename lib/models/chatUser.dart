class ChatUser {
  late String name;
  late String email;
  late String img;
  late String about;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActiv;
  late String pushToken;
  ChatUser({
    required this.name,
    required this.email,
    required this.about,
    required this.createdAt,
    required this.id,
    required this.img,
    required this.isOnline,
    required this.lastActiv,
    required this.pushToken,
  });

  ChatUser.fromjson({required Map<String, dynamic> json}) {
    name = json["name"] ?? "";
    email = json["email"] ?? "";
    about = json["about"] ?? "";
    createdAt = json["createdAt"] ?? "";
    id = json["id"] ?? "";
    img = json["img"] ?? "";
    isOnline = json["isOnline"] ?? "";
    lastActiv = json["lastActiv"] ?? "";
    pushToken = json["pushToken"] ?? "";
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {};
    _data["name"] = name;
    _data["email"] = email;
    _data["about"] = about;
    _data["createdAt"] = createdAt;
    _data["img"] = img;
    _data["id"] = id;
    _data["isOnline"] = isOnline;
    _data["lastActiv"] = lastActiv;
    _data["pushToken"] = pushToken;
    return _data;
  }
}
