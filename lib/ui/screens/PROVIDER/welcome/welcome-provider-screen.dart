import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/login/login_provider_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/sign_up/sign_up_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeProviderScreen extends StatefulWidget {
  @override
  _WelcomeProviderScreenState createState() => _WelcomeProviderScreenState();
}

class _WelcomeProviderScreenState extends State<WelcomeProviderScreen> {
  Widget build(BuildContext context) {
    ///
    /// Splash Screen UI goes here.
    ///
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //first space bar element
            SizedBox(height: 80.h),
            //second element
            Column(
              children: [
                Center(
                  child: Image.asset(
                    '$static_assets/updated_logo.jpeg',
                    width: 1.sw,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            ///third element
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 167.h,
                        height: 52.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.w),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0.r),
                        ),
                        child: RoundedRaisedButton(
                          buttonText: "LOGIN",
                          onPressed: () {
                            Get.to(() => LoginProviderScreen());
                          },
                          color: Colors.white,
                          freeTrialColor: Colors.white,
                          textColor: Colors.black,
                        ),
                        // Text(
                        //   "LOGIN",
                        //   style: bodyTextStyle.copyWith(
                        //       fontFamily: robottoFontTextStyle,
                        //       fontSize: 13.sp,
                        //       color: Colors.black,
                        //       letterSpacing: 0.4,
                        //       fontWeight: FontWeight.bold),
                        //   textAlign: TextAlign.center,
                        // ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 167.h,
                        height: 52.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.w),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Container(
                          width: 167.h,
                          height: 52.w,
                          child: RoundedRaisedButton(
                            buttonText: "REGISTER",
                            onPressed: () {
                              Get.to(() => SignUpProviderScreen());
                            },
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
