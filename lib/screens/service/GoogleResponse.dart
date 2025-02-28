class BusinessModel {
  String businessStatus;
  String formattedAddress;
  Geometry geometry;
  String icon;
  String name;
  OpeningHours openingHours;
  List<Photo> photos;
  String placeId;
  PlusCode plusCode;
  double rating;
  int userRatingsTotal;

  BusinessModel({
    required this.businessStatus,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.name,
    required this.openingHours,
    required this.photos,
    required this.placeId,
    required this.plusCode,
    required this.rating,
    required this.userRatingsTotal,
  });

  /// Initialize with default values
  static BusinessModel initialize() {
    return BusinessModel(
      businessStatus: '',
      formattedAddress: '',
      geometry: Geometry.initialize(),
      icon: '',
      name: '',
      openingHours: OpeningHours.initialize(),
      photos: [],
      placeId: '',
      plusCode: PlusCode.initialize(),
      rating: 0.0,
      userRatingsTotal: 0,
    );
  }

  /// Convert JSON to Model
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      businessStatus: json['business_status'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      geometry: Geometry.fromJson(json['geometry'] ?? {}),
      icon: json['icon'] ?? '',
      name: json['name'] ?? '',
      openingHours: OpeningHours.fromJson(json['opening_hours'] ?? {}),
      photos: (json['photos'] as List?)
          ?.map((p) => Photo.fromJson(p))
          .toList() ??
          [],
      placeId: json['place_id'] ?? '',
      plusCode: PlusCode.fromJson(json['plus_code'] ?? {}),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      userRatingsTotal: json['user_ratings_total'] ?? 0,
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'business_status': businessStatus,
      'formatted_address': formattedAddress,
      'geometry': geometry.toJson(),
      'icon': icon,
      'name': name,
      'opening_hours': openingHours.toJson(),
      'photos': photos.map((p) => p.toJson()).toList(),
      'place_id': placeId,
      'plus_code': plusCode.toJson(),
      'rating': rating,
      'user_ratings_total': userRatingsTotal,
    };
  }
}

class Geometry {
  Location location;
  Viewport viewport;

  Geometry({required this.location, required this.viewport});

  static Geometry initialize() {
    return Geometry(
      location: Location.initialize(),
      viewport: Viewport.initialize(),
    );
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location'] ?? {}),
      viewport: Viewport.fromJson(json['viewport'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'viewport': viewport.toJson(),
    };
  }
}

class Location {
  double lat;
  double lng;

  Location({required this.lat, required this.lng});

  static Location initialize() {
    return Location(lat: 0.0, lng: 0.0);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Viewport {
  Location northeast;
  Location southwest;

  Viewport({required this.northeast, required this.southwest});

  static Viewport initialize() {
    return Viewport(
      northeast: Location.initialize(),
      southwest: Location.initialize(),
    );
  }

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: Location.fromJson(json['northeast'] ?? {}),
      southwest: Location.fromJson(json['southwest'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': northeast.toJson(),
      'southwest': southwest.toJson(),
    };
  }
}

class OpeningHours {
  bool openNow;

  OpeningHours({required this.openNow});

  static OpeningHours initialize() {
    return OpeningHours(openNow: false);
  }

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json['open_now'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open_now': openNow,
    };
  }
}

class Photo {
  int height;
  String photoReference;
  int width;

  Photo({
    required this.height,
    required this.photoReference,
    required this.width,
  });

  static Photo initialize() {
    return Photo(height: 0, photoReference: '', width: 0);
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'] ?? 0,
      photoReference: json['photo_reference'] ?? '',
      width: json['width'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'photo_reference': photoReference,
      'width': width,
    };
  }
}

class PlusCode {
  String compoundCode;
  String globalCode;

  PlusCode({required this.compoundCode, required this.globalCode});

  static PlusCode initialize() {
    return PlusCode(compoundCode: '', globalCode: '');
  }

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json['compound_code'] ?? '',
      globalCode: json['global_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compound_code': compoundCode,
      'global_code': globalCode,
    };
  }
}
