import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/locator.dart';

class CustomerBookingScreenViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  var serviceToBeAdded = SErvice();
  List<SErvice> filteredServices = [];
  List<SErvice> services = [];

  CustomerBookingScreenViewModel() {
    updatedBookingStatus(serviceToBeAdded);
    getAllServices();
  }

  updatedBookingStatus(SErvice serviceToBeEditted) async {
    final uid = serviceToBeEditted.id;
    print("Provider user service uid is======>$uid");
    setState(ViewState.loading);
    if (uid != null) {
      //now add to myservices
      print("UPDATING");
      await _dbService.updateMyService(serviceToBeEditted, uid);
      await _dbService.updateInGlobalService(serviceToBeEditted);
      //serviceToBeEditted = SErvice();
    } else {
      print("Sorry your uid is null");
    }
    setState(ViewState.idle);
  }

  getAllServices() async {
    services = [];
    setState(ViewState.loading);
    // final uuid = _localStorageService.accessTokenProvider;
    services = await _dbService.getGlobalServices();
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }

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
