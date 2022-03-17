import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class SErvice {
  String? id;
  String? providerId;
  String? title;
  String? providerName;
  String? description;
  String? price;
  Locationn? location;
  String? category;
  String? websiteLink;
  String? imgUrl;
  String? availability;
  File? imgFile;
  String? isBooked;
  DateTime? datetime;
  Timestamp? serviceBookingDate;
  String? isConfirmed;
  String? fcmToken = 'hello';

  SErvice(
      {this.title,
      this.id,
      this.providerId,
      this.description,
      this.price,
      this.location,
      this.providerName,
      this.imgFile,
      this.category,
      this.websiteLink,
      this.imgUrl,
      this.availability,
      this.isBooked,
      this.serviceBookingDate,
      this.isConfirmed,
      this.fcmToken});

  SErvice.fromJson(json, id) {
    this.id = id;
    providerId = json['providerId'];
    title = json['title'];
    providerName = json['providerName'];
    description = json['description'];
    price = json['price'];
    location = json['location'] != null
        ? new Locationn.fromJson(json['location'])
        : null;
    category = json['category'];
    websiteLink = json['website_link'];
    imgUrl = json['imgUrl'];
    availability = json['availability'];
    isBooked = json['isBooked'];
    serviceBookingDate = json['serviceBookingDate'];
    isConfirmed = json['isConfirmed'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['providerName'] = this.providerName;
    data['description'] = this.description;
    data['providerId'] = this.providerId;
    data['price'] = this.price;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    } else {
      data['location'] = Locationn();
    }
    data['category'] = this.category;
    data['website_link'] = this.websiteLink;
    data['imgUrl'] = this.imgUrl;
    data['availability'] = this.availability;
    data['isBooked'] = this.isBooked;
    data['serviceBookingDate'] = this.serviceBookingDate;
    data['isConfirmed'] = this.isConfirmed;
    data['fcmToken'] = this.fcmToken;

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
