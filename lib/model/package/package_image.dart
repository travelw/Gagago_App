
class ImageData {
  int? id;
  int? packageId;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  ImageData({
    this.id,
    this.packageId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json["id"],
    packageId: json["package_id"],
    image: json["image"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "package_id": packageId,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}