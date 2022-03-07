

import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

class HomeViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();
  late BaseResponse response;
  List<SErvice> services = [];

  HomeViewModel() {
    getAllServices();
  }

  getAllServices() async {
    services = [];
    setState(ViewState.busy);
    final uuid = _localStorageService.accessTokenProvider;
    print("UUID ===========> " + uuid);
    services = await _dbService.getAllProviderServices(uuid);
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }
}
