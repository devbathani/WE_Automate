import 'dart:io';

class Product {
  String? id;
  String? providerId;
  String? title;
  String? description;
  String? price;
  Locationn? location;
  String? category;
  String? websiteLink;
  String? imgUrl;
  String? availability;
  File? imgFile;

  Product({
    this.title,
    this.id,
    this.description,
    this.providerId,
    this.price,
    this.location,
    this.availability,
    this.category,
    this.websiteLink,
    this.imgUrl,
    this.imgFile,
  });

  Product.fromJson(json, id) {
    this.id = id;
    title = json['title'];
    providerId = json['providerId'];
    description = json['description'];
    price = json['price'];
    location = json['location'] != null
        ? new Locationn.fromJson(json['location'])
        : null;
    category = json['category'];
    websiteLink = json['website_link'];
    imgUrl = json['imgUrl'];
    availability = json['availability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['providerId'] = this.providerId;
    data['description'] = this.description;
    data['price'] = this.price;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['category'] = this.category;
    data['website_link'] = this.websiteLink;
    data['imgUrl'] = this.imgUrl;
    data['availability'] = this.availability;
    return data;
  }
}

class Locationn {
  String? lat;
  String? long;

  Locationn({this.lat, this.long});

  Locationn.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
