import 'dart:developer';
import 'dart:io';

import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/product.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import '../../../../../locator.dart';

class ProviderSearchDetailViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  // final _localStorageService = locator<LocalStorageService>();
  late BaseResponse response;
  List<Product> products = [];
  List<Product> filteredProducts = [];

  ProviderSearchDetailViewModel() {
    getAllProducts();
  }
  getAllProducts() async {
    products = [];
    setState(ViewState.loading);
    // final uuid = _localStorageService.accessTokenProvider;
    products = await _dbService.getGlobalProducts();
    // response = await _dbService.getDashboardData();
    setState(ViewState.idle);
  }

  ///
  /// A function that will filtered tags and called on searchBar textfield onchanged functions
  ///
  searchProducts(value) {
    print("@SearchServices/");
    filteredProducts = products
        .where((s) => s.title!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    // notifyListeners();
    setState(ViewState.idle);
    //for debugging purpose
    print(filteredProducts.map((e) => e.title).toList());
  }
}
