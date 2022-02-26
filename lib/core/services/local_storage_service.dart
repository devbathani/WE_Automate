import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  ///
  /// List of const keys
  ///
  static const String onboardingCountKeyCustomer = 'onBoardingCountCustomer';
  static const String onboardingCountKeyStylist = 'onBoardingCountStylist';
  static const String notificationsCountKey = 'snotificationsCount';
  static const String accessTokenKeyCustomer = 'accessTokenCustomer';
  static const String accessTokenKeyProvider = 'accessTokenProvider';
  static const String refreshTokenKey = 'refreshToken';

  ///
  /// Setters and getters
  ///

  int get setNotificationsCount => _getFromDisk(notificationsCountKey) ?? 0;
  set setNotificationsCount(int count) =>
      _saveToDisk(notificationsCountKey, count);

  ///
  /// Setters and getters for custom
  /// er accessToken
  ///

  dynamic get accessTokenCustomer =>
      _getFromDisk(accessTokenKeyCustomer) ?? null;
  set setAccessTokenCustomer(String? token) =>
      _saveToDisk(accessTokenKeyCustomer, token);

  ///
  /// Setters and getters for Stylist accessToken
  ///

  dynamic get accessTokenProvider =>
      _getFromDisk(accessTokenKeyProvider) ?? null;
  set setAccessTokenProvider(String? token) =>
      _saveToDisk(accessTokenKeyProvider, token);

  dynamic get refreshToken => _getFromDisk(refreshTokenKey) ?? null;
////
  ///setters and getters for customer onboarding count
  ///
  int get onBoardingPageCountCustomer =>
      _getFromDisk(onboardingCountKeyCustomer) ?? 0;
  set setOnBoardingPageCountCustomer(int count) =>
      _saveToDisk(onboardingCountKeyCustomer, count);

////
  ///setters and getters for customer onboarding count
  ///
  int get onBoardingPageCountStylist =>
      _getFromDisk(onboardingCountKeyStylist) ?? 0;
  set setOnBoardingPageCountStylist(int count) =>
      _saveToDisk(onboardingCountKeyStylist, count);
////
  ///initializing instance
  ///
  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences!.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences!.setString(key, content);
    }
    if (content is bool) {
      _preferences!.setBool(key, content);
    }
    if (content is int) {
      _preferences!.setInt(key, content);
    }
    if (content is double) {
      _preferences!.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences!.setStringList(key, content);
    }
    if (content == null) {
      _preferences!.remove(key);
    }
  }

  // static Future<LocalStorageService> getInstance() async {
  //   if (_instance == null) {
  //     _instance = LocalStorageService();
  //   }
  //   if (_preferences == null) {
  //     _preferences = await SharedPreferences.getInstance();
  //   }
  //   return _instance!;
  // }
}
