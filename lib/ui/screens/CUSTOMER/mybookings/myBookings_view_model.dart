import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/locator.dart';

class MyBookingViewModel extends BaseViewModel {
  List<SErvice> services = [];

  MyBookingViewModel() {
    getAllServices();
  }

  final _dbService = locator<DatabaseService>();
  getAllServices() async {
    services = [];
    setState(ViewState.loading);
    // final uuid = _localStorageService.accessTokenProvider;
    services = await _dbService.getGlobalServices();
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }

 
}
