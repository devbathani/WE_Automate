import 'package:antonx_flutter_template/core/enums/user-type.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/custom-auth-response.dart';
import 'package:antonx_flutter_template/core/services/device_info_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/core/services/notification-service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/auth_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../locator.dart';
import 'auth_exception_handler.dart';
import 'database_service.dart';

///
/// [AuthService] class contains all authentication related logic with following
/// methods:
///
/// [doSetup]: This method contains all the initial authentication like checking
/// login status, onboarding status and other related initial app flow setup.
///
/// [signupWithEmailAndPassword]: This method is used for signup with email and password.
///
/// [signupWithApple]:
///
/// [signupWithGmail]:
///
/// [signupWithFacebook]:
///
/// [logout]:
///

class AuthService {
  late bool isCustomerLogin;
  late bool isProviderLogin;
  final _localStorageService = locator<LocalStorageService>();
  final _dbService = locator<DatabaseService>();
  AppUser? customerProfile;
  AppUser? providerProfile;
  final _auth = FirebaseAuth.instance;
  CustomAuthResponse customAuthResponseProvider = CustomAuthResponse();
  CustomAuthResponse customAuthResponseCustomer = CustomAuthResponse();

  String? fcmToken;
  static final Logger log = Logger();

  ///
  /// [doSetup] Function does the following things:
  ///   1) Checks if the user is logged then:
  ///       a) Get the user profile data
  ///       b) Updates the user FCM Token
  ///
  doSetup() async {
    isCustomerLogin = _localStorageService.accessTokenCustomer != null;
    isProviderLogin = _localStorageService.accessTokenProvider != null;
    if (isCustomerLogin) {
      print(
          'Customer user logged in  =====>${_localStorageService.accessTokenCustomer}');
      await _getUserProfile(UserType.customer);
      // await _updateFcmToken();
    } else if (isProviderLogin) {
      print(
          'Provider user logged in====>${_localStorageService.accessTokenProvider}');
      await _getUserProfile(UserType.provider);
      // await _updateFcmToken();
    } else {
      print('User is not logged-in');
    }
  }

  _getUserProfile(UserType userType) async {
    if (userType == UserType.customer) {
      var cuser = await _dbService
          .getCustomerUserData(_localStorageService.accessTokenCustomer);
      if (cuser != null) {
        customerProfile = cuser;
      } else {
        Get.dialog(AuthDialog(title: 'Response', message: "Unexpected Error"));
      }
    } else {
      var pUser = await _dbService
          .getProviderUserData(_localStorageService.accessTokenProvider);
      if (pUser != null) {
        providerProfile = pUser;
      } else {
        Get.dialog(AuthDialog(title: 'Response', message: "Unexpected Error"));
      }
    }
  }

  ///
  /// Updating FCM Token here...
  ///
  _updateFcmToken() async {
    final fcmToken = await locator<NotificationsService>().getFcmToken();
    final deviceId = await DeviceInfoService().getDeviceId();
    // final response = await _dbService.updateFcmToken(deviceId, fcmToken!);
    // if (response.success) {
    customerProfile!.fcmToken = fcmToken;
    providerProfile!.fcmToken = fcmToken;
    // }
  }

  AuthService() {
    print('@FirebaseAuthService');
  }

////
  ///This function will signup user with email and password
  ///
  // @override
  Future<CustomAuthResponse> signUpProviderWithEmailPassword(
      {AppUser? providerUser}) async {
    print('@services/signUpProviderWithEmailPassword');
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: providerUser!.email!, password: providerUser.password!);
      if (authResult.user == null) {
        customAuthResponseProvider.status = false;
        customAuthResponseProvider.errorMessage =
            'An undefined Error happened.';
      } else {
        ////uploading image to storage first
        // providerUser.imgUrl = await _dbService.uploadFile(
        //     providerUser.imgFile!, 'provider_user', '${providerUser.email}');

        providerUser.uid = authResult.user!.uid;
        providerUser.fcmToken =
            await locator<NotificationsService>().getFcmToken();
        customAuthResponseProvider.status = true;
        customAuthResponseProvider.user = authResult.user;
        customAuthResponseProvider.provider = providerUser;
        providerProfile = providerUser;

        await _dbService.registerProviderUser(providerUser);

        _localStorageService.setAccessTokenProvider = authResult.user!.uid;
      }
    } catch (e) {
      print('Exception @signUpStylistWithEmailPassword: $e');
      customAuthResponseProvider.status = false;
      customAuthResponseProvider.errorMessage =
          AuthExceptionHandler.generateExceptionMessage(e);
    }
    return customAuthResponseProvider;
  }

/////
  ///
  ///This function will login user with email and password
  ///
  // @override
  Future<CustomAuthResponse> loginProviderWithEmailPassword(
      {email, password}) async {
    try {
      // var authResult;
      print('@AuthService/loginWithEmailAndPasswordProvider');
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      /// If user login fails without any exception and error code
      if (authResult.user == null) {
        customAuthResponseProvider.status = false;
        customAuthResponseProvider.errorMessage =
            'An undefined Error happened.';
        return customAuthResponseProvider;
      }

      ///
      /// If firebase auth is successful:
      ///
      /// Check if there is a user account associated with
      /// this uid in the database.
      /// If yes, then proceed to the auth success otherwise
      /// logout the user and generate an error for the user.
      ///
      if (authResult.user != null) {
        final providerUser =
            await _dbService.getProviderUserData(authResult.user!.uid);

        if (providerUser == null) {
          customAuthResponseProvider.status = false;
          await logout();
          customAuthResponseProvider.errorMessage =
              "You don't have account. Please create one and then proceed to login.";
          return customAuthResponseProvider;
        }
        customAuthResponseProvider.status = true;
        customAuthResponseProvider.user = authResult.user;
        customAuthResponseCustomer.provider = providerUser;
        providerProfile = providerUser;
        _localStorageService.setAccessTokenProvider = authResult.user!.uid;
        // customAuthResult.notFirebaseUser = user;
      }
    } catch (e) {
      customAuthResponseProvider.status = false;
      customAuthResponseProvider.errorMessage =
          // e.toString();
          AuthExceptionHandler.generateExceptionMessage(e);
      print("@loginwithEmailAndPasswordProvider/Exception =====> $e");
    }
    return customAuthResponseProvider;
  }

/////
  ///
  ///CUSTOMER Authentication function
  ///
  ///
////
  ///This function will signup user with email and password
  ///
  // @override
  Future<CustomAuthResponse> signUpCustomerWithEmailPassword(
      {AppUser? customerUser}) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: customerUser!.email!, password: customerUser.password!);
      if (authResult.user == null) {
        customAuthResponseCustomer.status = false;
        customAuthResponseCustomer.errorMessage =
            'An undefined Error happened.';
      } else {
        ////uploading image to storage first
        // providerUser.imgUrl = await _dbService.uploadFile(
        //     providerUser.imgFile!, 'provider_user', '${providerUser.email}');

        customerUser.uid = authResult.user!.uid;
        customerUser.fcmToken =
            await locator<NotificationsService>().getFcmToken();
        customAuthResponseCustomer.status = true;
        customAuthResponseCustomer.user = authResult.user;
        customAuthResponseCustomer.provider = customerUser;
        customerProfile = customerUser;

        await _dbService.registerCustomerUser(customerUser);

        _localStorageService.setAccessTokenCustomer = authResult.user!.uid;
      }
    } catch (e) {
      print('Exception @signUpCustomerWithEmailPassword: $e');
      customAuthResponseCustomer.status = false;
      customAuthResponseCustomer.errorMessage =
          AuthExceptionHandler.generateExceptionMessage(e);
    }
    return customAuthResponseCustomer;
  }

/////
  ///
  ///This function will login Customer user with email and password
  ///
  // @override
  Future<CustomAuthResponse> loginCustomerWithEmailPassword(
      {email, password}) async {
    try {
      // var authResult;
      print('@AuthService/loginCustomerWithEmailPassword');
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      /// If user login fails without any exception and error code
      if (authResult.user == null) {
        customAuthResponseCustomer.status = false;
        customAuthResponseCustomer.errorMessage =
            'An undefined Error happened.';
        return customAuthResponseCustomer;
      }

      ///
      /// If firebase auth is successful:
      ///
      /// Check if there is a user account associated with
      /// this uid in the database.
      /// If yes, then proceed to the auth success otherwise
      /// logout the user and generate an error for the user.
      ///
      if (authResult.user != null) {
        final customerUser =
            await _dbService.getCustomerUserData(authResult.user!.uid);
        if (customerUser == null) {
          customAuthResponseCustomer.status = false;
          await logout();
          customAuthResponseCustomer.errorMessage =
              "You don't have account. Please create one and then proceed to login.";
          return customAuthResponseCustomer;
        }
        customAuthResponseCustomer.status = true;
        customAuthResponseCustomer.user = authResult.user;
        customAuthResponseCustomer.customer = customerUser;
        customerProfile = customerUser;

        _localStorageService.setAccessTokenCustomer = authResult.user!.uid;

        // customAuthResult.notFirebaseUser = user;
      }
    } catch (e) {
      customAuthResponseCustomer.status = false;
      customAuthResponseCustomer.errorMessage =
          //  e.toString();
          AuthExceptionHandler.generateExceptionMessage(e);
    }
    return customAuthResponseCustomer;
  }

////
  ///
  ///This function is used for login user anonymously
  ///
  // @override
  Future<CustomAuthResponse> loginAnonymously() async {
    // try {
    //   var user = USER();
    //   var authResult;
    //   print('@AuthService/loginAnonymously');
    //   authResult = await _auth.signInAnonymously();

    /// If user login fails without any exception and error code
    // if (authResult.user == null) {
    //   customAuthResult.status = false;
    //   customAuthResult.errorMessage = 'An undefined Error happened.';
    //   return customAuthResult;
    // }

    ///
    /// If firebase auth is successful:
    ///
    /// Check if there is a user account associated with
    /// this uid in the database.
    /// If yes, then proceed to the auth success otherwise
    /// logout the user and generate an error for the user.
    ///
    //   if (authResult.user == null) {
    //     customAuthResult.status = false;
    //     customAuthResult.errorMessage = 'An undefined Error happened.';
    //     return customAuthResult;
    //   } else {
    //     user.uid = authResult.user.uid;
    //     user.phone = "DEVICE_MAC_ADDRESS";
    //     customAuthResult.status = true;
    //     customAuthResult.user = authResult.user;

    //     final fcm = await locator<NotificationsService>().getFcmToken();
    //     user.fcmToken = fcm;
    //     // user.fcmToken = await FirebaseMessaging().getToken();
    //     await _dbService.registerGuestUser(user);
    //   }
    // } catch (e) {
    //   customAuthResult.status = false;
    //   customAuthResult.errorMessage =
    //       //  e.toString();
    //       AuthExceptionHandler.generateExceptionMessage(e);
    // }
    return customAuthResponseCustomer;
  }

  // @override
  // Future<CustomAuthResult> loginWithFacebook() async {
  //   //TODO: Register app with facebook and do sdk settings.

  //   try {
  //     ///Login with Facebook
  //     FacebookLogin facebookLogin = FacebookLogin();
  //     facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //     final result = await facebookLogin.logIn(['email']);
  //     final token = result.accessToken.token ?? "";

  //     if (result.errorMessage != null)
  //       print("Result error msg : " + result.errorMessage);
  //     //Get User info
  //     final graphResponse = await http.get(
  //         'https://graph.facebook.com/v2.12/me?fields=name,email&access_token=${token}');
  //     print(graphResponse.body);

  //     //Implement Firebase Auth
  //     if (result.status == FacebookLoginStatus.loggedIn) {
  //       final credential =
  //           FacebookAuthProvider.getCredential(accessToken: token);
  //       final authResult = await _auth.signInWithCredential(credential);

  //       ///Update Userinfo in Firestore
  //       if (authResult.user != null) {
  //         customAuthResult.status = true;
  //         customAuthResult.user = authResult.user;

  //         //TODO: Create Account in Database
  //         User _user = new User(
  //           uid: authResult.user.uid,
  //           email: authResult.user.email,
  //           fullName: authResult.user.displayName,
  //           imgUrl: authResult.user.photoUrl,
  //           contact: authResult.user.phoneNumber,
  //         );
  //         _user.fcmToken = await FirebaseMessaging().getToken();
  //         await _dbService.registerUser(_user);
  //         print(_user.toJson().toString());
  //         print("Logged in");
  //       } else {
  //         customAuthResult.status = false;
  //         customAuthResult.errorMessage = 'An undefined Error happened.';
  //         print("An undefined Error happened");
  //       }
  //     }
  //   } catch (e) {
  //     print("Error occured while loggin with Facebok in Auth Service: " +
  //         e.toString());
  //   }
  //   return customAuthResult;
  // }

  // ///
  // /// Google SignIn
  // ///
  // @override
  // Future<CustomAuthResult> loginWithGoogle() async {
  //   //Todo: Do settings in the Google cloud for 0Auth Credentials
  //   try {
  //     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     final authResult = await _auth.signInWithCredential(credential);
  //     if (authResult.user != null) {
  //       customAuthResult.status = true;
  //       customAuthResult.user = authResult.user;

  //       //TODO: Create Account in Database
  //       User _user = new User(
  //         uid: authResult.user.uid,
  //         email: authResult.user.email,
  //         fullName: authResult.user.displayName,
  //         imgUrl: authResult.user.photoUrl,
  //         contact: authResult.user.phoneNumber,
  //       );
  //       _user.fcmToken = await FirebaseMessaging().getToken();
  //       await _dbService.registerUser(_user);
  //       print("Logged in");
  //     } else {
  //       customAuthResult.status = false;
  //       customAuthResult.errorMessage = 'An undefined Error happened.';
  //       print("An undefined Error happened");
  //     }
  //   } catch (e) {
  //     customAuthResult.status = false;
  //     customAuthResult.errorMessage =
  //         AuthExceptionHandler.generateExceptionMessage(e);
  //     print("Error happened: " + e.toString());
  //   }
  //   return customAuthResult;
  // }

  // @override
  Future<void> logout({String? id}) async {
    // _dbService.updateFcmToken(null, id);
    isCustomerLogin = false;
    isProviderLogin = false;
    customerProfile = null;
    providerProfile = null;
    await _auth.signOut();
    // await _dbService.clearFcmToken(await DeviceInfoService().getDeviceId());
    _localStorageService.setAccessTokenCustomer = null; //"null";
    _localStorageService.setAccessTokenProvider = null; //"null";
    // await _googleSignIn.signOut();
  }

  // @override
  // Future<CustomAuthResult> updateAccount(UserUpdateInfo updatedInfo) {
  //   // TODO: implement updateAccount
  //   throw UnimplementedError();
  // }

  // @override
  // void resetPassword(String email) {
  //   try {
  //     _auth.sendPasswordResetEmail(email: email);
  //   } catch (e) {
  //     print('Exception @FirebaseAuthService/resetPassword: $e');
  //   }
  // }
}
