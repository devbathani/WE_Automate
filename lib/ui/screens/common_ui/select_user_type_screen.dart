import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/auth_signup/login/login_customer_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/welcome/welcome_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/login/login_provider_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/welcome/welcome-provider-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectUserTypeScreen extends StatefulWidget {
  @override
  _SelectUserTypeScreenState createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    ///
    /// Splash Screen UI goes here.
    ///
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "WEautomate.co",
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: Text("user@weautomate.co",
                  style: TextStyle(color: Colors.black)),
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: AssetImage("assets/static_assets/avatar0.png"),
              // ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/static_assets/app_icon.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage("assets/static_assets/profile_avatar.png"),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage("assets/static_assets/avatar03.png"),
                ),
              ],
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/static_assets/free_trial.svg',
                height: 25.h,
              ),
              title: Text("Free trial"),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                'assets/static_assets/person.png',
                height: 25.h,
              ),
              title: Text("Client"),
              onTap: () {
                Get.to(
                  () => CustomerWelcomeScreen(),
                );
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/static_assets/provider.svg',
                height: 25.h,
              ),
              title: Text("Provider"),
              onTap: () {
                Get.to(
                  () => WelcomeProviderScreen(),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/static_assets/contact.png',
                height: 25.h,
              ),
              title: Text("Contact"),
              onTap: () {},
            )
          ],
        ),
      ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //first space bar element
            SizedBox(height: 80.h),
            //second element
            Center(
              child: Image.asset(
                '$static_assets/updated_logo.jpeg',
                width: 1.sw,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => WelcomeProviderScreen(),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16.w),
                    height: 100.h,
                    width: 166.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: Color(0XFF262626).withOpacity(0.8),
                    ),
                    child: Center(
                      child: Text(
                        'Provider',
                        style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => CustomerWelcomeScreen(),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 4.w),
                    height: 100.h,
                    width: 166.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: Color(0XFF262626).withOpacity(0.8),
                    ),
                    child: Center(
                      child: Text(
                        'Client',
                        style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            InkWell(
              onTap: () {},
              child: Container(
                height: 100.h,
                width: 320.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  color: Color(0XFFf4f4f4),
                ),
                child: Center(
                  child: Text(
                    'Free Trial',
                    style: GoogleFonts.poppins(
                        fontSize: 22.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
          ],
        ),
      ),
    );
  }
}
