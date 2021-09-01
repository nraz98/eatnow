class VenueSearch {
  String id;
  String name;
  Location location;
  List<Categories> categories;
  String referralId;
  bool hasPerk;
  VenuePage venuePage;

  VenueSearch(
      {this.id,
      this.name,
      this.location,
      this.categories,
      this.referralId,
      this.hasPerk,
      this.venuePage});

  VenueSearch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    referralId = json['referralId'];
    hasPerk = json['hasPerk'];
    venuePage = json['venuePage'] != null
        ? new VenuePage.fromJson(json['venuePage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['referralId'] = this.referralId;
    data['hasPerk'] = this.hasPerk;
    if (this.venuePage != null) {
      data['venuePage'] = this.venuePage.toJson();
    }
    return data;
  }
}

class Location {
  String address;
  double lat;
  double lng;
  List<LabeledLatLngs> labeledLatLngs;
  int distance;
  String postalCode;
  String cc;
  String city;
  String state;
  String country;
  List<String> formattedAddress;
  String crossStreet;
  String neighborhood;

  Location(
      {this.address,
      this.lat,
      this.lng,
      this.labeledLatLngs,
      this.distance,
      this.postalCode,
      this.cc,
      this.city,
      this.state,
      this.country,
      this.formattedAddress,
      this.crossStreet,
      this.neighborhood});

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    if (json['labeledLatLngs'] != null) {
      labeledLatLngs = new List<LabeledLatLngs>();
      json['labeledLatLngs'].forEach((v) {
        labeledLatLngs.add(new LabeledLatLngs.fromJson(v));
      });
    }
    distance = json['distance'];
    postalCode = json['postalCode'];
    cc = json['cc'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    formattedAddress = json['formattedAddress'].cast<String>();
    crossStreet = json['crossStreet'];
    neighborhood = json['neighborhood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    if (this.labeledLatLngs != null) {
      data['labeledLatLngs'] =
          this.labeledLatLngs.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    data['postalCode'] = this.postalCode;
    data['cc'] = this.cc;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['formattedAddress'] = this.formattedAddress;
    data['crossStreet'] = this.crossStreet;
    data['neighborhood'] = this.neighborhood;
    return data;
  }
}

class LabeledLatLngs {
  String label;
  double lat;
  double lng;

  LabeledLatLngs({this.label, this.lat, this.lng});

  LabeledLatLngs.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Categories {
  String id;
  String name;
  String pluralName;
  String shortName;
  IconSearch icon;
  bool primary;

  Categories(
      {this.id,
      this.name,
      this.pluralName,
      this.shortName,
      this.icon,
      this.primary});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pluralName = json['pluralName'];
    shortName = json['shortName'];
    icon = json['icon'] != null ? new IconSearch.fromJson(json['icon']) : null;
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pluralName'] = this.pluralName;
    data['shortName'] = this.shortName;
    if (this.icon != null) {
      data['icon'] = this.icon.toJson();
    }
    data['primary'] = this.primary;
    return data;
  }
}

class IconSearch {
  String prefix;
  String suffix;

  IconSearch({this.prefix, this.suffix});

  IconSearch.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    suffix = json['suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prefix'] = this.prefix;
    data['suffix'] = this.suffix;
    return data;
  }
}

class VenuePage {
  String id;

  VenuePage({this.id});

  VenuePage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
