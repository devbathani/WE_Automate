import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './app-user.dart';

class CustomAuthResponse {
  bool? status;
  String? errorMessage;
  User? user;
  AppUser? customer;
  AppUser? provider;

  CustomAuthResponse(
      {this.status,
      this.errorMessage,
      this.user,
      this.customer,
      this.provider});
}
