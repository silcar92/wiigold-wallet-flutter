import 'dart:convert';

class Claim {
  final String id;
  final String name;

  Claim({required this.id, required this.name});

  factory Claim.fromJson(Map<String, dynamic> json) =>
      Claim(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class ClaimCategory {
  final String id;
  final String name;
  final List<Claim> details;

  ClaimCategory({required this.id, required this.name, required this.details});

  factory ClaimCategory.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List? ?? [];
    List<Claim> claims = detailsList.map((i) => Claim.fromJson(i)).toList();

    return ClaimCategory(id: json["id"], name: json["name"], details: claims);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}
