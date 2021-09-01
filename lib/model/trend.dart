class TrendingModel {
  String type;
  String name;
  List<Items> items;

  TrendingModel({this.type, this.name, this.items});

  TrendingModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }
}

class Items {
  Reasons reasons;
  Venue venue;
  String referralId;

  Items({this.reasons, this.venue, this.referralId});

  Items.fromJson(Map<String, dynamic> json) {
    reasons =
        json['reasons'] != null ? new Reasons.fromJson(json['reasons']) : null;
    venue = json['venue'] != null ? new Venue.fromJson(json['venue']) : null;
    referralId = json['referralId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reasons != null) {
      data['reasons'] = this.reasons.toJson();
    }
    if (this.venue != null) {
      data['venue'] = this.venue.toJson();
    }
    data['referralId'] = this.referralId;
    return data;
  }
}

class Reasons {
  int count;
  List<ItemReason> itemReason;

  Reasons({this.count, this.itemReason});

  Reasons.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      itemReason = new List<ItemReason>();
      json['items'].forEach((v) {
        itemReason.add(new ItemReason.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.itemReason != null) {
      data['items'] = this.itemReason.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemReason {
  String summary;
  ItemReason({this.summary});

  ItemReason.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    return data;
  }
}

class Venue {
  String id;
  String name;
  LocationTrend location;
  List<CategoriesTrend> categories;

  Venue({this.id, this.name, this.location, this.categories});

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'] != null
        ? new LocationTrend.fromJson(json['location'])
        : null;
    if (json['categories'] != null) {
      categories = new List<CategoriesTrend>();
      json['categories'].forEach((v) {
        categories.add(new CategoriesTrend.fromJson(v));
      });
    }
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

    return data;
  }
}

class LocationTrend {
  double lat;
  double lng;

  LocationTrend({
    this.lat,
    this.lng,
  });

  LocationTrend.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class CategoriesTrend {
  String pluralName;
  String shortName;

  CategoriesTrend({
    this.pluralName,
    this.shortName,
  });

  CategoriesTrend.fromJson(Map<String, dynamic> json) {
    pluralName = json['pluralName'];
    shortName = json['shortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pluralName'] = this.pluralName;
    data['shortName'] = this.shortName;

    return data;
  }
}
