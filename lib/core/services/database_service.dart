import 'dart:io';

import 'package:antonx_flutter_template/core/constants/api_end_pionts.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/body/login_body.dart';
import 'package:antonx_flutter_template/core/models/body/reset_password_body.dart';
import 'package:antonx_flutter_template/core/models/body/signup_body.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/core/models/product.dart';
import 'package:antonx_flutter_template/core/models/reponses/auth_response.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/request_response.dart';
import 'package:antonx_flutter_template/core/models/reponses/onboarding_reponse.dart';
import 'package:antonx_flutter_template/core/models/reponses/user_profile_response.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/services/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  final ApiServices _apiServices = ApiServices();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final firestoreRef = FirebaseFirestore.instance;

  ///
  ///uploadfile
  ///

  uploadFile(File file, reference, fileName) async {
    print("@UploadFile=====>${file.path}");
    String? downloadURL;
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('$reference/$fileName')
          .putFile(file)
          .whenComplete(() async {
        downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref('$reference/$fileName')
            .getDownloadURL();
      });

      print("UPLOADED IMAGE URL IS +========> $downloadURL");

      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("Exception @UploadFile====>$e");
    }
  }

  ///
  ///upload provider User
  ///
  Future<void> registerProviderUser(AppUser providerUser) async {
    print('@registerProviderUser: uid is ${providerUser.uid}');
    try {
      await firestoreRef
          .collection('provider_user')
          .doc(providerUser.uid)
          .set(providerUser.toJson());
    } catch (e) {
      print('Exception @registerProviderUser: $e');
      throw e;
    }
  }

  Future<void> registerCustomerUser(AppUser customerUser) async {
    print('@registerCustomreUser: uid is ${customerUser.uid}');
    try {
      await firestoreRef
          .collection('customer_user')
          .doc(customerUser.uid)
          .set(customerUser.toJsonCustomer());
    } catch (e) {
      print('Exception @registerCustomreUser: $e');
      throw e;
    }
  }

  // //this will get user data for authentication purpose
  Future<AppUser?> getProviderUserData(uid) async {
    print('@DatabaseService/getProviderUserData of user ==> $uid');
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('provider_user')
          .doc(uid)
          .get();
      if (snapshot.data != null) {
        final user = AppUser.fromJson(snapshot.data(), uid);
        print('@DatabaseService/getProviderUserData: ${user.toJson()}');
        return user;
      } else {
        print('User Data is null');
        return null;
      }
    } catch (e) {
      print('Exception @getUserData: $e');
      return null;
    }
  }

  // //this will get user data for authentication purpose
  Future<AppUser?> getCustomerUserData(uid) async {
    print('@DatabaseService/getCustomerUserData of user ==> $uid');
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('customer_user')
          .doc(uid)
          .get();
      if (snapshot.data != null) {
        final user = AppUser.fromJsonCustomer(snapshot.data(), uid);
        print('@DatabaseService/getCustomerUserData: ${user.toJsonCustomer()}');
        return user;
      } else {
        print('User Data is null');
        return null;
      }
    } catch (e) {
      print('Exception @getCustomerUserData: $e');
      return null;
    }
  }

  Future<UserProfileResponse> getUserProfile() async {
    final RequestResponse response = await _apiServices.get(
        url: '${EndPoints.baseUrl}${EndPoints.userProfile}');
    return UserProfileResponse.fromJson(response.data);
  }

  Future<OnboardingResponse> getOnboardingData() async {
    final RequestResponse response = await _apiServices.get(
        url: '${EndPoints.baseUrl}${EndPoints.onboardingData}');
    return OnboardingResponse.fromJson(response.data);
  }

  Future<BaseResponse> updateFcmToken(String deviceId, String token) async {
    final RequestResponse response = await _apiServices.post(
      url: '${EndPoints.baseUrl}${EndPoints.fcm_token}',
      data: {
        'device_id': deviceId,
        'token': token,
      },
    );
    return BaseResponse.fromJson(response.data);
  }

  Future<BaseResponse> clearFcmToken(String deviceId) async {
    final RequestResponse response = await _apiServices.post(
      url: '${EndPoints.baseUrl}${EndPoints.clear_fcm_token}',
      data: {'device_id': deviceId},
    );
    return BaseResponse.fromJson(response.data);
  }

  Future<AuthResponse> loginWithEmailAndPassword(LoginBody body) async {
    final RequestResponse response = await _apiServices.post(
      url: '${EndPoints.baseUrl}${EndPoints.login}',
      data: body.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> createAccount(SignUpBody body) async {
    final RequestResponse response = await _apiServices.post(
      url: '${EndPoints.baseUrl}${EndPoints.signup}',
      data: body.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> resetPassword(ResetPasswordBody body) async {
    final RequestResponse response = await _apiServices.post(
      url: '${EndPoints.baseUrl}${EndPoints.reset_password}',
      data: body.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  getAllProviderServices(uuid) async {
    print("getAllProviderServices/");
    try {
      List<SErvice> services = [];
      // DocumentSnapshot docSnapshot =
      QuerySnapshot snapshot = await firestoreRef
          .collection('provider_user')
          .doc(uuid)
          .collection('services')
          .get();

      if (snapshot.docs.isEmpty) {
        print("Your services snapshot is empty");
        // attraction = Attraction(name: "notfound");
        // print("ITEM NOT FOUND ==> ${attraction.toJson()}");
      } else {
        snapshot.docs.forEach((element) {
          // print("each iteration=> ${element['title']}");
          services.add(SErvice.fromJson(element, element.id));
        });
      }
      return services;
    } catch (e, s) {
      print("Exception/getAllProviderServices=========> $e, $s");
    }
  }

  getAllProviderProducts(uuid) async {
    print("getAllProviderProducts/");
    try {
      List<Product> products = [];
      // DocumentSnapshot docSnapshot =
      QuerySnapshot snapshot = await firestoreRef
          .collection('provider_user')
          .doc(uuid)
          .collection('products')
          .get();

      if (snapshot.docs.isEmpty) {
        print("Your product snapshot is empty");
        // attraction = Attraction(name: "notfound");
        // print("ITEM NOT FOUND ==> ${attraction.toJson()}");
      } else {
        snapshot.docs.forEach((element) {
          // print("each iteration=> ${element['title']}");
          products.add(Product.fromJson(element, element.id));
        });
      }
      return products;
    } catch (e, s) {
      print("Exception/getAllProviderProducts=========> $e, $s");
    }
  }

  getGlobalProducts() async {
    print("getGlobalProducts/");
    try {
      List<Product> products = [];
      // DocumentSnapshot docSnapshot =
      QuerySnapshot snapshot =
          await firestoreRef.collection('global_products').get();

      if (snapshot.docs.isEmpty) {
        print("Your product snapshot is empty");
        // attraction = Attraction(name: "notfound");
        // print("ITEM NOT FOUND ==> ${attraction.toJson()}");
      } else {
        snapshot.docs.forEach((element) {
          // print("each iteration=> ${element['title']}");
          products.add(Product.fromJson(element, element.id));
        });
      }
      return products;
    } catch (e, s) {
      print("Exception/getGlobalProducts=========> $e, $s");
    }
  }

  getGlobalServices() async {
    print("getGlobalServices/");
    try {
      List<SErvice> services = [];
      // DocumentSnapshot docSnapshot =
      QuerySnapshot snapshot =
          await firestoreRef.collection('global_services').get();

      if (snapshot.docs.isEmpty) {
        print("Your product snapshot is empty");
        // attraction = Attraction(name: "notfound");
        // print("ITEM NOT FOUND ==> ${attraction.toJson()}");
      } else {
        snapshot.docs.forEach(
          (element) {
            // print("each iteration=> ${element['title']}");
            services.add(
              SErvice.fromJson(element, element.id),
            );
          },
        );
      }
      return services;
    } catch (e, s) {
      print("Exception/getGlobalServices=========> $e, $s");
    }
  }

  Future<void> addToGlobalServices(SErvice service) async {
    print('@addToGlobalServices:}');
    try {
      await firestoreRef.collection('global_services').add(service.toJson());
    } catch (e) {
      print('Exception @addToGlobalServices: $e');
    }
  }

  Future<void> updateInGlobalService(SErvice service) async {
    print('@updateInGlobalService:}');
    try {
      await firestoreRef
          .collection('global_services')
          .doc(service.id)
          .set(service.toJson());
    } catch (e) {
      print('Exception @updateInGlobalService: $e');
    }
  }

  Future<void> addToGlobalProducts(Product product) async {
    print('@addToGlobalProducts:}');
    try {
      await firestoreRef.collection('global_products').add(product.toJson());
    } catch (e) {
      print('Exception @addToGlobalProducts: $e');
    }
  }

  Future<void> addToMyServices(SErvice service, uid) async {
    print('@addToMyServices:}');
    try {
      await firestoreRef
          .collection('provider_user')
          .doc(uid)
          .collection('services')
          .add(service.toJson());
    } catch (e) {
      print('Exception @addToMyServices: $e');
    }
  }

  Future<void> updateMyService(SErvice edittedService, uid) async {
    print('@updateMyService: =======serviceid==> ${edittedService.id}}');
    try {
      await firestoreRef
          .collection('provider_user')
          .doc(uid)
          .collection('services')
          .doc(edittedService.id)
          .update(edittedService.toJson());
    } catch (e) {
      print('Exception @updateMyService: $e');
    }
  }

  Future<void> updateBusinessDetails(AppUser appUser, uid) async {
    print("UPDATING");
    try {
      await firestoreRef
          .collection('provider_user')
          .doc(uid)
          .update(appUser.toJson());
    } catch (e) {
      print('Exception @updateMyService: $e');
    }
  }

  Future<void> updateMyProduct(Product edittedProduct, uid) async {
    print('@updateMyProduct: =======serviceid==> ${edittedProduct.id}}');
    try {
      await firestoreRef
          .collection('provider_user')
          .doc(uid)
          .collection('products')
          .doc(edittedProduct.id)
          .update(edittedProduct.toJson());
    } catch (e) {
      print('Exception @updateMyProduct: $e');
    }
  }

  Future<void> addToMyProducts(Product product, uid) async {
    print('@addToMyProducts}');
    try {
      await firestoreRef
          .collection('provider_user')
          .doc(uid)
          .collection('products')
          .add(product.toJson());
    } catch (e) {
      print('Exception @addToMyProducts: $e');
    }
  }

//   Future<void> addService(Service service, uid) async {
//     print('@addService:===================> USER UID is ==> $uid ');
//     try {
//       await firestoreRef
//           .collection('provider_user')
//           .doc(uid)
//           .collection('services')
//           // .doc(addedCar.id)
//           .doc()
//           .set(service.toJson());
//       // .add(bookedCar.toJson());
//     } catch (e) {
//       print('Exception @addToMyCars: $e');
//     }
//   }

  Future<void> sendMessage({
    Message? message,
    chatId,
  }) async {
    print('@SendMessage:===================> chatId==> $chatId ');
    try {
      final customerId = chatId.toString().split('_').first;
      final providerId = chatId.toString().split('_').last;

      ///
      ///we will do two things whenever someone send message
      ///1-send a messsage to that user
      ///2-set a last message to that conversation/chat
      ///
      await FirebaseFirestore.instance
          .collection('customer_user')
          .doc(customerId)
          .collection('chat')
          .doc(chatId)
          .collection('messages')
          .add(message!.toJson());

      ///now set a last message of conversation too for customer
      await FirebaseFirestore.instance
          .collection('customer_user')
          .doc(customerId)
          .collection('chat')
          .doc(chatId)
          // .collection('messages')
          .set(message.toJson2());

      ///
      ///NOW doing the same for provider
      ///
      await FirebaseFirestore.instance
          .collection('provider_user')
          .doc(providerId)
          .collection('chat')
          .doc(chatId)
          .collection('messages')
          .add(message.toJson());

      ///now set a last message of conversation too for customer
      await FirebaseFirestore.instance
          .collection('provider_user')
          .doc(providerId)
          .collection('chat')
          .doc(chatId)
          // .collection('messages')
          .set(message.toJson2());
    } catch (e) {
      print('Exception @SendMessage: $e');
    }
  }
}