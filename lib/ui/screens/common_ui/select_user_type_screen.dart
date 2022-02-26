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
import 'package:get/get.dart';

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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 128.h,
                        height: 41.w,
                        child: RoundedRaisedButton(
                          buttonText: "PROVIDER",
                          onPressed: () {
                            Get.to(
                              () => WelcomeProviderScreen(),
                            );
                          },
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 13.w,
                      ),
                      Container(
                        width: 128.h,
                        height: 41.w,
                        child: RoundedRaisedButton(
                          buttonText: "CLIENT",
                          onPressed: () {
                            Get.to(
                              () => CustomerWelcomeScreen(),
                            );
                          },
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 38),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 128.h,
                          height: 41.w,
                          color: yellowColor,
                          child: RoundedRaisedButton(
                            buttonText: "FREE TRIAL",
                            onPressed: () {},
                            textColor: Colors.black,
                            freeTrialColor: yellowColor,
                            color: yellowColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
