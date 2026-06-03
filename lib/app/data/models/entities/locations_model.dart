class Country {
  final int id;
  final String name;
  final String abbreviation;
  final String abbreviationAlpha2;

  Country({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.abbreviationAlpha2,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
      abbreviationAlpha2: json['abbreviationAlpha2'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'abbreviationAlpha2': abbreviationAlpha2,
    };
  }

  @override
  String toString() {
    return 'Country(id: $id, name: $name, abbreviation: $abbreviation)';
  }
}

class Region {
  final int id;
  final String name;
  final String countryAbbreviation;
  final int geonameId;

  Region({
    required this.id,
    required this.name,
    required this.countryAbbreviation,
    required this.geonameId,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      countryAbbreviation: json['country_abbreviation'] as String? ?? '',
      geonameId: json['geoname_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country_abbreviation': countryAbbreviation,
      'geoname_id': geonameId,
    };
  }

  @override
  String toString() {
    return 'Region(id: $id, name: $name, country: $countryAbbreviation)';
  }
}
