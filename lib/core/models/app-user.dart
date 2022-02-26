import 'dart:io';

class AppUser {
  String? uid;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? password;
  String? imgUrl;
  String? createdAt;
  String? fcmToken;
  File? imgFile;

  //feilds from provider
  String? businessName;
  String? typeOfBusiness;
  String? description;
  String? address;
  bool? isBipoc = false;
  bool? isOther = false;

//customer feilds

  String? firstName;
  String? lastName;

  AppUser({
    this.uid,
    this.email,
    this.imgFile,
    this.password,
    this.fullName,
    this.imgUrl,
    this.fcmToken,
    this.phoneNumber,
    this.createdAt,
    this.businessName,
    this.typeOfBusiness,
    this.description,
    this.address,
    this.firstName,
    this.lastName,
    this.isBipoc = false,
    this.isOther = false,
  });

  AppUser.fromJson(json, uid) {
    uid = uid;
    email = json['email'];
    imgUrl = json['imgUrl'];
    fcmToken = json['fcmToken'];
    // fullName = json['full_name'];
    // phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    //provider one
    businessName = json['business_name'];
    typeOfBusiness = json['type_business'];
    description = json['description'];
    address = json['address'];
    isBipoc = json['isBipoc'] ?? false;
    isOther = json['isOther'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.uid;
    data['fcmToken'] = this.fcmToken;
    data['email'] = this.email;
    data['imgUrl'] = this.imgUrl;
    // data['full_name'] = this.fullName;
    // data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;

    //provider one
    data['business_name'] = this.businessName;
    data['type_business'] = this.typeOfBusiness;
    data['description'] = this.description;
    data['address'] = this.address;
    data['isBipoc'] = this.isBipoc;
    data['isOther'] = this.isOther;
    return data;
  }

/////
  ///CUSTOMER FROM JSON AND TOJSON
  ///
  ///
  AppUser.fromJsonCustomer(json, uid) {
    uid = uid;
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    imgUrl = json['imgUrl'];
    fcmToken = json['fcmToken'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    address = json['address'];
  }

  Map<String, dynamic> toJsonCustomer() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.uid;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['fcmToken'] = this.fcmToken;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['imgUrl'] = this.imgUrl;
    data['created_at'] = this.createdAt;
    data['address'] = this.address;
    return data;
  }
}
