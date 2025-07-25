import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int? id;
  String? name;
  String? desc;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isFavorite = false;

  Product({this.id, this.name, this.desc, this.createdAt, this.updatedAt});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

List<Favorite> favoriteFromJson(String str) =>
    List<Favorite>.from(json.decode(str).map((x) => Favorite.fromJson(x)));

String favoriteToJson(List<Favorite> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorite {
  String? userId;
  int? productId;

  Favorite({required this.userId, required this.productId});
  factory Favorite.fromJson(Map<String, dynamic> json) =>
      Favorite(userId: json["user_id"], productId: json["product_id"]);
  Map<String, dynamic> toJson() => {"user_id": userId, "product_id": productId};
}
