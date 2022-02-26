import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/custom-auth-response.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../locator.dart';

class CustomerAuthViewModel extends BaseViewModel {
  final _auth = FirebaseAuth.instance;
  bool _isLogin = false;
  User? _firebaseUser;
  bool _authStatus = false;
  String? errorMessage;
  AuthService _authService = locator<AuthService>();
  final _dbService = locator<DatabaseService>();
  AppUser customerUser = AppUser();

  bool isRemeberMe = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisibility = true;

  togglePasswordVisibility() {
    setState(ViewState.busy);
    passwordVisibility = !passwordVisibility;
    setState(ViewState.idle);
  }

  CustomerAuthViewModel() {
    print('@CustomerAuthViewModel');
    // _checkIfLogin();

    // /// Listen for changes in authStatus
    // _auth.onAuthStateChanged.listen(
    //   (firebaseUser) async {
    //     _firebaseUser = firebaseUser;
    //     _isLogin = (_firebaseUser != null) ? true : false;
    //     print('User Login status: $_isLogin');
    //     if (_isLogin) {
    //       print('CurrentUid: ${_firebaseUser.uid}');
    //       user = await _dbService.getUserData(_firebaseUser.uid);
    //       print('${user?.toJson()}');
    //     } else {
    //       user = User();
    //     }
    //     notifyListeners();
    //   },
    // );
  }

  // _checkIfLogin() async {
  //   print('@checkIfLogin');
  //   final user = await _auth.currentUser();
  //   if (user != null) {
  //     _isLogin = true;
  //     print('@authModel/checkIfLogin, loginStatus: $_isLogin');
  //     notifyListeners();
  //   }
  // }

  ///
  /// *** Getters ***
  ///
  /// Login status variables are made private, so that
  /// they are not changed unintentionally from any other
  /// Except this AuthProvider class with proper protocol
  ///
  User? get firebaseUser => _firebaseUser;

  bool get isLogin => _isLogin;

  bool get status => _authStatus;

  ///
  /// authentication methods
  ///
  Future<bool> createAccount() async {
    print('@ViewModel/createAccount');
    setState(ViewState.busy);
    final CustomAuthResponse authResult = await _authService
        .signUpCustomerWithEmailPassword(customerUser: customerUser);
    if (authResult.status!) {
      /// if true, process success
      _authStatus = true;

      _firebaseUser = authResult.user;
      customerUser.uid = authResult.user!.uid;
      print(customerUser.uid);

      // customerUser.email = authResult.user!.email;
      // customerUser.firstName = authResult.user!.firstName;
      // customerUser.lastName = authResult.user.lastName;
      // customerUser.imgUrl = authResult.notFirebaseUser.imgUrl;
      // customerUser.phone = authResult.notFirebaseUser.phone;

      // user.imgUrl = "${authResult.notFirebaseUser.imgUrl}";
      // print(
      //     "Rent USER AVATAR URL==========>${authResult.notFirebaseUser.imgUrl}");
    } else {
      /// if false, process failed
      _authStatus = false;
      errorMessage = authResult.errorMessage;
    }

    /// Calling notify listener isn't required here
    /// as it's already called in setState method.
    setState(ViewState.idle);
    return _authStatus;
  }

  ///
  /// Login with Email and Password Functions
  ///
  Future<bool> loginWithEmailPassword() async {
    print("LoginWithUserEmailAndPasswrd====> ${customerUser.toJson()}");
    setState(ViewState.busy);
    final CustomAuthResponse authResult =
        await _authService.loginCustomerWithEmailPassword(
            email: customerUser.email, password: customerUser.password);
    if (authResult.status ?? false) {
      /// if true, login success
      _authStatus = true;
      _firebaseUser = authResult.user;
      // user.uid = authResult.user.uid;
      // user.email = authResult.notFirebaseUser.email;
      // user.firstName = authResult.notFirebaseUser.firstName;
      // user.lastName = authResult.notFirebaseUser.lastName;
      // user.imgUrl = authResult.notFirebaseUser.imgUrl;
      // user.phone = authResult.notFirebaseUser.phone;
      // print("USER LOGIN SUCCESSFULLY ======>${user.uid}");

      // final fcm = await locator<NotificationsService>().getFcmToken();
      // _dbService.updateRentFcmToken(fcm, authResult.user.uid);
      // user.fcmToken=fcm;
      print("LoginWithUserEmailAndPasswrd====> ${customerUser.toJson()}");
    } else {
      /// if false, login failed
      _authStatus = false;
      errorMessage = authResult.errorMessage;
    }
    emailController.clear();
    passwordController.clear();

    /// Calling notify listener isn't required here
    /// as it's already called in setState method.
    setState(ViewState.idle);
    return _authStatus;
  }

  ///
  /// Login with Facebook
  ///
  // Future<bool> loginWithFacebook({user, isImam = false}) async {
  //   setState(ViewState.busy);
  //   final CustomAuthResult authResult = await _authService.loginWithFacebook();
  //   if (authResult.status) {
  //     /// if true, login success
  //     _authStatus = true;
  //   } else {
  //     /// if false, login failed
  //     _authStatus = false;
  //     errorMessage = authResult.errorMessage;
  //   }

  //   /// Calling notify listener isn't required here
  //   /// as it's already called in setState method.
  //   setState(ViewState.idle);
  //   return _authStatus;
  // }

  // ///
  // /// Login with Google
  // ///
  // Future<bool> loginWithGoogle({user, isImam = false}) async {
  //   setState(ViewState.busy);
  //   final CustomAuthResult authResult = await _authService.loginWithGoogle();
  //   if (authResult.status) {
  //     /// if true, login success
  //     _authStatus = true;
  //   } else {
  //     /// if false, login failed
  //     _authStatus = false;
  //     errorMessage = authResult.errorMessage;
  //   }

  //   /// Calling notify listener isn't required here
  //   /// as it's already called in setState method.
  //   setState(ViewState.idle);
  //   return _authStatus;
  // }

  // updateAccount() {
  //   //Todo: To be implemented
  // }

  logout() {
    _authService.logout();
    notifyListeners();
  }

  // resetPassword(String email){
  //   _authService.resetPassword(email);
  // }
}
