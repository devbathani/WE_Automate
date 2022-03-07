import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/models/app-user.dart';
import '../../../../core/services/local_storage_service.dart';

class BookingViewModel extends BaseViewModel {
  List<SErvice> services = [];
  FirebaseAuth user = FirebaseAuth.instance;
  DateTime dateTime = DateTime.now();
  final firestoreRef = FirebaseFirestore.instance;
  Timestamp timestamp = Timestamp.now();
  final _localStorageService = locator<LocalStorageService>();
  late AppUser appuser;
  BookingViewModel() {
    getGlobalService();
    getCustomerData();
  }

  final _dbService = locator<DatabaseService>();

  getGlobalService() async {
    services = [];
    setState(ViewState.loading);
    services = await _dbService.getGlobalServices();
    setState(ViewState.idle);
  }

  getCustomerData() async {
    setState(ViewState.loading);
    appuser = (await _dbService
        .getCustomerUserData(_localStorageService.accessTokenCustomer))!;

    setState(ViewState.idle);
  }

  fetchDates(DateTime selecteddate) async {
    services = [];
    setState(ViewState.loading);
    var datainstance = FirebaseFirestore.instance
        .collection('global_services')
        .doc('PI47AVoqQjaCZ8AcKEps');

    await datainstance.get().then((DocumentSnapshot snapshot) async {
      Timestamp timestamp = snapshot.get(FieldPath(['serviceBookingDate']));
      String title = snapshot.get(FieldPath(['title']));
      String websiteLink = snapshot.get(FieldPath(['website_link']));
      String category = snapshot.get(FieldPath(['category']));
      String description = snapshot.get(FieldPath(['description']));
      String imgUrl = snapshot.get(FieldPath(['imgUrl']));
      String isBooked = snapshot.get(FieldPath(['isBooked']));
      String isConfirmed = snapshot.get(FieldPath(['isConfirmed']));
      String price = snapshot.get(FieldPath(['price']));
      String availability = snapshot.get(FieldPath(['availability']));
      String fcmToken = snapshot.get(FieldPath(['fcmToken']));
      String providerId = snapshot.get(FieldPath(['providerId']));
      String providerName = snapshot.get(FieldPath(['providerName']));

      DateTime myDateTime = timestamp.toDate();
      print(myDateTime);
      if (snapshot.exists) {
        if (selecteddate.year == myDateTime.year) {
          if (selecteddate.month == myDateTime.month) {
            if (selecteddate.day == myDateTime.day) {
              services.add(
                SErvice(
                  serviceBookingDate: timestamp,
                  title: title,
                  websiteLink: websiteLink,
                  category: category,
                  description: description,
                  imgUrl: imgUrl,
                  isBooked: isBooked,
                  isConfirmed: isConfirmed,
                  providerName: providerName,
                  price: price,
                  availability: availability,
                  fcmToken: fcmToken,
                  providerId: providerId,
                ),
              );
              print("Service Booking dates are selected");
              print(services);
            }
          }
        }
      } else {
        print('We good some error!!!');
      }
    });
    setState(ViewState.idle);
  }

  updatedBookingStatus(SErvice serviceToBeEditted) async {
    setState(ViewState.loading);
    print("UPDATING");

    await _dbService.updateInGlobalService(serviceToBeEditted);
    setState(ViewState.idle);
  }
}
