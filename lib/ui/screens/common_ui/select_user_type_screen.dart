import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/welcome/welcome_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/welcome/welcome-provider-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectUserTypeScreen extends StatefulWidget {
  @override
  _SelectUserTypeScreenState createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen> {
  @override
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
                Get.to(
                  () => WelcomeProviderScreen(),
                );
              },
              child: Container(
                height: 90.h,
                width: 330.w,
                decoration: BoxDecoration(
                  color: Color(0XFF1b77f2),
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
                        "$static_assets/owner.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        "Owner",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
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
                Get.to(
                  () => CustomerWelcomeScreen(),
                );
              },
              child: Container(
                height: 90.h,
                width: 330.w,
                decoration: BoxDecoration(
                  color: Color(0XFF1b77f2),
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
                        "$static_assets/customer.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        "Customer",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
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
