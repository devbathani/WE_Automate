import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/auth_signup/login/login_customer_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/auth_signup/sign_up/sign_up_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerWelcomeScreen extends StatefulWidget {
  @override
  _CustomerWelcomeScreenState createState() => _CustomerWelcomeScreenState();
}

class _CustomerWelcomeScreenState extends State<CustomerWelcomeScreen> {
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
                Get.to(() => LoginCustomerScreen());
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
                        "$static_assets/female.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w300,
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
                Get.to(() => SignUpCustomerScreen());
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
                        "$static_assets/register.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Text(
                        "Register",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w300,
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
