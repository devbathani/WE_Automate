import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/login/login_provider_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/sign_up/sign_up_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeProviderScreen extends StatefulWidget {
  @override
  _WelcomeProviderScreenState createState() => _WelcomeProviderScreenState();
}

class _WelcomeProviderScreenState extends State<WelcomeProviderScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150.h),
            Center(
              child: Image.asset(
                '$static_assets/updated_logo.jpeg',
                width: 250.w,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            InkWell(
              onTap: () {
                Get.to(() => LoginProviderScreen());
              },
              child: Container(
                height: 90.h,
                width: 330.w,
                decoration: BoxDecoration(
                  color: Color(0xff8B53FF),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Image.asset(
                        "$static_assets/female.png",
                        height: 60.h,
                        width: 60.w,
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Text(
                        "Login",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () {
                Get.to(() => SignUpProviderScreen());
              },
              child: Container(
                height: 90.h,
                width: 330.w,
                decoration: BoxDecoration(
                  color: Color(0xff8B53FF),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Image.asset(
                        "$static_assets/female.png",
                        height: 60.h,
                        width: 60.w,
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        "Register",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
