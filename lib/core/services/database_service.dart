import 'dart:io';

import 'package:antonx_flutter_template/core/constants/api_end_pionts.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/body/login_body.dart';
import 'package:antonx_flutter_template/core/models/body/reset_password_body.dart';
import 'package:antonx_flutter_template/core/models/body/signup_body.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/core/models/order_data.dart';
import 'package:antonx_flutter_template/core/models/product.dart';
import 'package:antonx_flutter_template/core/models/reponses/auth_response.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/request_response.dart';
import 'package:antonx_flutter_template/core/models/reponses/onboarding_reponse.dart';
import 'package:antonx_flutter_template/core/models/reponses/user_profile_response.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/models/slot_data_model.dart';
import 'package:antonx_flutter_template/core/models/time_slot.dart';
import 'package:antonx_flutter_template/core/services/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/schedule_info.dart';

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
      if (snapshot.data() != null) {
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

  getProvidersInfo() async {
    try {
      List<AppUser> appuser = [];
      // DocumentSnapshot docSnapshot =
      QuerySnapshot snapshot =
          await firestoreRef.collection('provider_user').get();

      if (snapshot.docs.isEmpty) {
        print("Your product snapshot is empty");
        // attraction = Attraction(name: "notfound");
        // print("ITEM NOT FOUND ==> ${attraction.toJson()}");
      } else {
        snapshot.docs.forEach((element) {
          // print("each iteration=> ${element['title']}");
          appuser.add(AppUser.fromJson(element, element.id));
        });
      }
      return appuser;
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

  //Map<int, Coin> map = Map.fromIterable(list, key: (item) => item.id, value: (item) => item);
  Future<bool> createProviderSlots(
      uid, List<SlotDataModel> scheduleList, List<DateTime> offdays) async {
    //print('@createProviderSlots: uid is ${providerUser.uid}');
    //FieldValue.arrayUnion(providerUser)

    var slotData = scheduleList.map((e) => e.toJson()).toList();
    var offData = offdays.map((e) => e.toIso8601String()).toList();

    List<TimeSlotData> timeSlots = [];
    //timeSlots.add(slotsList[0].start);

    for (int count = 0; count < scheduleList.length; count++) {
      SlotDataModel element = scheduleList[count];

      int totalHours = element.end.difference(element.start).inMinutes;
      int requireTime = element.breakDuration + element.gapDuration;
      int slotCount = totalHours ~/ requireTime;
      var requireSlots = List.generate(
          slotCount,
          (index) => TimeSlotData(
              id: index,
              time: element.start.add(Duration(minutes: requireTime * index)),
              scheduleId: count));
      timeSlots.addAll(requireSlots);
    }

    var timeSlotsFormat = timeSlots.map((e) => e.toJson()).toList();

    try {
      await firestoreRef.collection('provider_slot').doc(uid).set(
          {'schedule': slotData, "offdays": offData, 'slots': timeSlotsFormat});
      return true;
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      print('Exception @createProviderSlots: $e');
      return false;
      throw e;
    }
  }

  Future<ScheduleInfoData?> getProviderSlots(uid) async {
    print("getProviderSlots");
    try {
      List<SErvice> services = [];
      // DocumentSnapshot docSnapshot =
      DocumentSnapshot snapshot =
          await firestoreRef.collection('provider_slot').doc(uid).get();
      var data = snapshot.data() as Map<String, dynamic>;

      ScheduleInfoData object = ScheduleInfoData.fromJson(data);

      return object;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      print("Exception/getGlobalServices=========> $e, $s");
      return null;
    }
  }

  Future<bool> bookOrder(uid, consumer, schId, slotId,serviceId,date) async {
    print("bookOrder schId $schId slotId $slotId");
    try {
      List<SErvice> services = [];
      await firestoreRef.collection('order').doc().set({
        "providerId": uid,
        "consumerId": consumer,
        "scheduleId": schId,
        "timeslotId": slotId,
        "serviceId": serviceId,
        "date":date,
        "status": "pending"
      }).then((value) async {
        DocumentSnapshot snapshot =
            await firestoreRef.collection('provider_slot').doc(uid).get();
        var data = snapshot.data() as Map<String, dynamic>;
        data["slots"][slotId]["status"] = "pending";
        await firestoreRef.collection('provider_slot').doc(uid).update(data);
        return true;
      });
      return true;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      print("Exception/getGlobalServices=========> $e, $s");
      return false;
    }
  }

  Future<bool> bookingAction(uid, consumer, schId, slotId,OrderData orderData) async {
    print("getProviderSlots");
    try {
      DocumentSnapshot snapshot =
      await firestoreRef.collection('provider_slot').doc(uid).get();
      var data = snapshot.data() as Map<String, dynamic>;
      data["slots"][slotId]["status"] = "${orderData.status}";
      await firestoreRef.collection('provider_slot').doc(uid).update(data);

     await firestoreRef
          .collection('order').doc("${orderData.orderId}").update(orderData.toJson());

    return true;

    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      print("Exception/getGlobalServices=========> $e, $s");
      return false;
    }
  }

  Future<ScheduleInfoData?> getScheduleInfo(uid,{bool isProvider=false}) async {
    print("getProviderSlots");
    try {
      var schedule = await firestoreRef.collection("provider_slot").doc(uid).get();
      if(schedule.data()!=null){
        return ScheduleInfoData.fromJson(schedule.data() as Map<String,dynamic>);
      }else{
        return null;
      }


    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      print("Exception/getGlobalServices=========> $e, $s");
      return null;
    }
  }

  Future<List<OrderData>> getOrders(uid,{bool isProvider=false}) async {
    print("getProviderSlots");
    try {
      List<OrderData> orderList= [];
      QuerySnapshot querySnap = await firestoreRef
          .collection('order').where(isProvider?"providerId":"consumerId",isEqualTo: uid).get();



      for(var element in querySnap.docs){
        var schedule = await firestoreRef.collection("provider_slot").doc((element.data()! as Map)["providerId"]).get();
        var serviceInfo = await firestoreRef.collection("global_services").doc((element.data()! as Map)["serviceId"]).get();
        orderList.add(OrderData.fromJson(element.data() as Map<String,dynamic>)
          ..orderId=element.id
          ..schedule = ScheduleInfoData.fromJson(schedule.data() as Map<String, dynamic>)
            ..service = SErvice.fromJson(serviceInfo, (element.data()! as Map)["serviceId"])
        );
      }


    return orderList;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      print("Exception/getGlobalServices=========> $e, $s");
      return [];
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

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
