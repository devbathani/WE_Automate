import 'dart:io';

import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';

import '../../../../locator.dart';

class ServicesViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();
  List<SErvice> services = [];
  late SErvice sErvice;

  ServicesViewModel() {
    getAllServices();
  }
  getAllServices() async {
    final uuid = _localStorageService.accessTokenProvider;

    services = await _dbService.getAllProviderServices(uuid);
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }

  addToMyServices(SErvice servicesToBeAdded) async {
    final uid = _localStorageService.accessTokenProvider;
    print("Provider user  uid is======>$uid");
    setState(ViewState.loading);

    if (uid != null) {
      //  await uploadToStorage();
      var fileName = servicesToBeAdded.imgFile!.path.split('/').last;
      servicesToBeAdded.imgUrl = await uploadImages(
          File(servicesToBeAdded.imgFile!.path), '$fileName');
      //now add to myservices

      await _dbService.addToMyServices(servicesToBeAdded, uid);
      await addToGlobalServices(servicesToBeAdded);
      servicesToBeAdded.globalId = servicesToBeAdded.id;
      await _dbService.updateMyService(servicesToBeAdded, uid);
      //now after that add it locally as well
      services.add(servicesToBeAdded);
      print("Service length ====> ${services.length}");
      // servicesToBeAdded = SErvice();
    } else {
      print("Sorry your uid is null");
    }
    setState(ViewState.idle);
  }

  updateService(SErvice serviceToBeEditted) async {
    final uid = _localStorageService.accessTokenProvider;
    print("Provider user  uid is======>$uid");
    setState(ViewState.loading);

    if (uid != null) {
      //  await uploadToStorage();
      if (serviceToBeEditted.imgFile != null) {
        var fileName = serviceToBeEditted.imgFile!.path.split('/').last;
        serviceToBeEditted.imgUrl = await uploadImages(
            File(serviceToBeEditted.imgFile!.path), '$fileName');
      }
      //print("Global Service ::::::::::> " + serviceToBeEditted.globalId!);
      //now add to myservices
      // await _dbService.updateMyService(serviceToBeEditted, uid);
      // await _dbService.updateGlobalService(
      //   serviceToBeEditted,
      //   serviceToBeEditted.globalId,
      // );
      //now after that add it locally as well
    } else {
      print("Sorry your uid is null");
    }
    setState(ViewState.idle);
  }

  addToGlobalServices(service) async {
    setState(ViewState.loading);
    await _dbService.addToGlobalServices(service);
    // setState(ViewState.idle);
  }

  uploadImages(File file, String fileName) async {
    setState(ViewState.loading);
    // carToBeAdded.imgUrl
    var downloadFileUrl =
        await _dbService.uploadFile(file, 'provider_services', '$fileName');
    // setState(ViewState.idle);
    return downloadFileUrl;
  }
}
