import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:flutter/cupertino.dart';

import '../../../../locator.dart';

class EditBusinessDetialViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();

  bool passwordVisibility = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AppUser appUser = AppUser();
  EditBusinessDetialViewModel() {
    updateBusinessDetails(appUser);
  }

  updateBusinessDetails(AppUser appUser) async {
    final uuid = _localStorageService.accessTokenProvider;
    print("UID ==============> " + uuid);
    setState(ViewState.loading);
    if (appUser.uid != null) {
      //now add to myservices
      print("UPDATING");
      await _dbService.updateBusinessDetails(appUser, uuid);

      //serviceToBeEditted = SErvice();
    } else {
      print("Sorry your uid is null");
    }

    setState(ViewState.idle);
  }
}
