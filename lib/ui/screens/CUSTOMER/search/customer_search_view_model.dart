import 'dart:developer';
import 'dart:io';

import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/product.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import '../../../../../locator.dart';

class CustomerSearchServicesViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  // final _localStorageService = locator<LocalStorageService>();
  late BaseResponse response;
  List<SErvice> services = [];
  List<SErvice> filteredServices = [];
  List<AppUser> appUser = [];

  CustomerSearchServicesViewModel() {
    getAllServices();
  }
  getAllServices() async {
    services = [];
    setState(ViewState.loading);
    // final uuid = _localStorageService.accessTokenProvider;
    services = await _dbService.getGlobalServices();
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }



  ///
  /// A function that will filtered tags and called on searchBar textfield onchanged functions
  ///
  searchServices(value) {
    print("@SearchServices/");
    filteredServices = services
        .where((s) => s.title!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    // notifyListeners();
    setState(ViewState.idle);
    //for debugging purpose
    print(filteredServices.map((e) => e.title).toList());
  }
}
