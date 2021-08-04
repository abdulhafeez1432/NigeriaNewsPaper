
import 'dart:convert';


List<Site> siteFromJson(List jsonData) {
  return List<Site>.from(
      jsonData.map((x) => Site.fromJson(x)).toList());
}

String siteToJson(List<Site> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Site {
  String name;
  String logo;

  Site({
    this.name,
    this.logo,
  });

  factory Site.fromJson(dynamic json) => Site(
    name: json["name"] as String,
    logo: json["logo"] as String,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "logo": logo,
  };
}