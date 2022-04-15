import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/core/services/notification-service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/network_error_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../core/constants/strings.dart';
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
    await _notificationService.initConfigure();

    ///getting onboarding data for pre loading purpose
    await _authService.doSetup();

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: 600.h,
                width: w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xffCEDFEF).withOpacity(0.29),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.4,
                      0.9,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 50.h,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  '$assets/app_icon.png',
                  fit: BoxFit.cover,
                  height: 100.h,
                  width: 250.w,
                ),
              ),
            ),
            Positioned(
              top: 180.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Container(
                  width: 350.w,
                  child: Text(
                    "Get Everything you need to Grow Your Online business!",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300.h,
              left: 10.w,
              child: Container(
                height: 70.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    width: 0.05,
                    color: Colors.grey,
                  ),
                ),
                child: Image.asset(
                  '$static_assets/1_onboard.png',
                ),
              ),
            ),
            Positioned(
              top: 380.h,
              right: 10.w,
              child: Container(
                height: 70.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    width: 0.05,
                    color: Colors.grey,
                  ),
                ),
                child: Image.asset(
                  '$static_assets/2_onboard.png',
                ),
              ),
            ),
            Positioned(
              top: 460.h,
              left: 10.w,
              child: Container(
                height: 70.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    width: 0.05,
                    color: Colors.grey,
                  ),
                ),
                child: Image.asset(
                  '$static_assets/3_onboard.png',
                ),
              ),
            ),
            Positioned(
              top: 540.h,
              right: 10.w,
              child: Container(
                height: 70.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    width: 0.05,
                    color: Colors.grey,
                  ),
                ),
                child: Image.asset(
                  '$static_assets/4_onboard.png',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: getStartAndLoader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getStartAndLoader() {
    if (isInit) {
      return !_authService.isProviderLogin && !_authService.isCustomerLogin
          ? InkWell(
              onTap: () {
                Get.to(() => SelectUserTypeScreen());
              },
              child: Container(
                height: 60.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: Color(0XFF8B53FF),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Center(
                  child: Text(
                    "Get started for free",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 38),
              child: CircularProgressIndicator(
                color: Color(0XFF8B53FF),
              ),
            );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 38),
        child: CircularProgressIndicator(
          color: Color(0XFF8B53FF),
        ),
      );
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();

    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
