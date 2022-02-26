import 'dart:io';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/product.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';

import '../../../../locator.dart';

class ProductViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();
  List<Product> products = [];

  ProductViewModel() {
    getAllProducts();
  }
  getAllProducts() async {
    final uuid = _localStorageService.accessTokenProvider;
    setState(ViewState.loading);
    products = await _dbService.getAllProviderProducts(uuid);
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }

  addToMyProducts(Product productToBeAdded) async {
    final uid = _localStorageService.accessTokenProvider;
    print("Provider user  uid is======>$uid");
    setState(ViewState.loading);

    if (uid != null) {
      //  await uploadToStorage();
      var fileName = productToBeAdded.imgFile!.path.split('/').last;
      productToBeAdded.imgUrl =
          await uploadImages(File(productToBeAdded.imgFile!.path), '$fileName');
      //now add to myProducts
      await _dbService.addToMyProducts(productToBeAdded, uid);
      await addToGlobalProducts(productToBeAdded);
      //now after that add it locally as well
      products.add(productToBeAdded);
      productToBeAdded = Product();
    } else {
      print("Sorry your uid is null");
    }
    setState(ViewState.idle);
  }

  updateProduct(Product productToBediited, index) async {
    final uid = _localStorageService.accessTokenProvider;
    print("Provider user  uid is======>$uid");
    setState(ViewState.loading);

    if (uid != null) {
      //  await uploadToStorage();
      if (productToBediited.imgFile != null) {
        var fileName = productToBediited.imgFile!.path.split('/').last;
        productToBediited.imgUrl = await uploadImages(
            File(productToBediited.imgFile!.path), '$fileName');
      }
      //now add to myservices
      await _dbService.updateMyProduct(productToBediited, uid);
      // await updateInGlobalServices(serviceToBeEditted);
      //now after that add it locally as well
      products[index] = productToBediited;
      // servicesToBeAdded = SErvice();

    } else {
      print("Sorry your uid is null");
    }
    setState(ViewState.idle);
  }

  addToGlobalProducts(product) async {
    // setState(ViewState.loading);
    await _dbService.addToGlobalProducts(product);
    // setState(ViewState.idle);
  }

  uploadImages(File file, String fileName) async {
    // setState(ViewState.loading);
    // carToBeAdded.imgUrl
    var downloadFileUrl =
        await _dbService.uploadFile(file, 'provider_services', '$fileName');
    // setState(ViewState.idle);
    return downloadFileUrl;
  }
}
