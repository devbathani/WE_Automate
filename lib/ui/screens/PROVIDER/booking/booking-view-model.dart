import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingViewModel extends BaseViewModel {
  List<SErvice> services = [];
  FirebaseAuth user = FirebaseAuth.instance;
  DateTime dateTime = DateTime.now();
  final firestoreRef = FirebaseFirestore.instance;
  BookingViewModel() {
    getGlobalService();
    fetchDates(dateTime);
  }

  final _dbService = locator<DatabaseService>();

  getGlobalService() async {
    services = [];
    setState(ViewState.loading);
    services = await _dbService.getGlobalServices();
    setState(ViewState.loading);
  }

  fetchDates(DateTime selecteddate) async {
    services = [];
    DocumentSnapshot snapshot = await firestoreRef
        .collection('global_services')
        .doc(services.first.id)
        .get();

    setState(ViewState.loading);
    Timestamp myTimeStamp = snapshot.get(FieldPath(['serviceBookingDate']));
    DateTime myDateTime = myTimeStamp.toDate();

    if (selecteddate.year == myDateTime.year) {
      if (selecteddate.month == myDateTime.month) {
        if (selecteddate.day == myDateTime.day) {
          services.add(
            SErvice(serviceBookingDate: myTimeStamp),
          );
        }
      }
    }
    setState(ViewState.idle);
  }

  updatedBookingStatus(SErvice serviceToBeEditted) async {
    setState(ViewState.loading);
    print("UPDATING");

    await _dbService.updateInGlobalService(serviceToBeEditted);
    setState(ViewState.idle);
  }
}
