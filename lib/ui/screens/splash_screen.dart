import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/core/services/notification-service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/network_error_dialog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../locator.dart';
import 'CUSTOMER/root/root_screen.dart';
import 'PROVIDER/root/root-provider-screen.dart';
import 'common_ui/select_user_type_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = locator<AuthService>();
  final _dbService = locator<DatabaseService>();
  final _localStorateService = locator<LocalStorageService>();
  final _notificationService = locator<NotificationsService>();
  final _locationService = locator<LocationService>();
  final Logger log = Logger();
  bool isProviderLogin = false;
  bool isCustomerLogin = false;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    _initialSetup();
    super.didChangeDependencies();
  }

  _initialSetup() async {
    isInit = false;
    await _localStorateService.init();

    await _locationService.getCurrentLocation();

    ///
    /// If not connected to internet, show an alert dialog
    /// to activate the network connection.
    ///
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(NetworkErrorDialog());
      return;
    }

    ////
    ///initializing notification services
    ///
    // await NotificationsService().initConfigure();
    // var fcm = await NotificationsService().getFcmToken();
    // print("FCM TOKEN is =====> $fcm");
    await _notificationService.initConfigure();

    ///getting onboarding data for pre loading purpose
    // onboardingList = await _getOnboardingData();
//routing to the last onboarding screen user seen
    // if (_localStorateService.onBoardingPageCount + 1 < onboardingList.length) {
    //   final List<Image> preCachedImages =
    //       await _preCacheOnboardingImages(onboardingList);
    //   await Get.to(() => OnboardingScreen(
    //       currentIndex: _localStorateService.onBoardingPageCount,
    //       onboardingList: this.onboardingList,
    //       preCachedImages: preCachedImages));
    //   return;
    // }
    await _authService.doSetup();
    ////
    ///checking if the user is login or not
    ///
    // log.d('Login State: ${_authService.isLogin}');

    isInit = true;
    setState(() {});
    await Future.delayed(Duration(seconds: 2), () {});
    if (_authService.isProviderLogin) {
      isProviderLogin = true;
      Get.off(() => RootProviderScreen());
    } else if (_authService.isCustomerLogin) {
      isCustomerLogin = true;
      Get.off(() => RootSCustomercreen());
    } else {
      // Get.off(() => SelectUserTypeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// Splash Screen UI goes here.
    ///
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // child: Center(child: Text('Splash Screen')),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(
        //       "${assets}l.png",
        //     ),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //first space bar element
              SizedBox(height: 80.h),
              //second element
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "W",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 4, 67, 139),
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              "E",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 195, 224, 28),
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                "Automate",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 4, 67, 139),
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            // Image.asset(
                            //   'assets/static_assets/weautomate_logo.png',
                            //   height: 50.h,
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                        "Improving  sales and purchases automation by connecting businesses and customers in one market place.",
                        style: bodyTextStyle.copyWith(
                          color: Colors.black,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w900,
                          fontFamily: robottoFontTextStyle,
                        )),
                  )
                ],
              ),

              ///third element
              getStartAndLoader(),
            ],
          ),
        ),
      ),
    );
  }

  getStartAndLoader() {
    if (isInit) {
      return !_authService.isProviderLogin && !_authService.isCustomerLogin
          ? Column(
              children: [
                Text("let's start discovering !!",
                    style: bodyTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontFamily: robottoFontTextStyle,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 38),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 167.h,
                        height: 52.w,
                        child: InkWell(
                          child: ElevatedButton(
                            child: Text(
                              "START",
                              style: GoogleFonts.poppins(fontSize: 16.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 4, 67, 139),
                            ),
                            // fontWeight: FontWeight.w400,
                            onPressed: () async {
                              Get.to(() => SelectUserTypeScreen());
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 38),
              child: CircularProgressIndicator(
                color: Color(0XFF1A6094),
              ),
            );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 38),
        child: CircularProgressIndicator(
          color: Color(0XFF1A6094),
        ),
      );
      // Text("....", style: bodyTextStyle.copyWith(color: Colors.white));
    }
  }
}
