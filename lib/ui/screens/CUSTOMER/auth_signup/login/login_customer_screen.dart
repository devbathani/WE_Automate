import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/custom_text_field.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/auth_signup/customer_auth_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/auth_signup/sign_up/sign_up_customer_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginCustomerScreen extends StatefulWidget {
  @override
  State<LoginCustomerScreen> createState() => _LoginCustomerScreenState();
}

class _LoginCustomerScreenState extends State<LoginCustomerScreen> {
  //Todo: Do localization here.
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerAuthViewModel>(
      builder: (context, model, child) => ModalProgressHUD(
        inAsyncCall: model.state == ViewState.busy,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                    // color: greyColor,
                    ),

                ///
                /// Column Contain app Bar And  User profile Image
                ///
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 48.0, left: 16, right: 16),
                    child: Column(
                      children: [
                        ///
                        /// ========== This Section Contain Back Button And Avatar =============
                        ///
                        ///
                        ///back button
                        ///
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              ImageContainer(
                                assets: "$static_assets/back.png",
                                height: 10,
                                width: 10,
                              ),
                              SizedBox(width: 13.29),
                              Text(
                                "BACK",
                                style: subHeadingTextstyle.copyWith(
                                    fontSize: 13.sp,
                                    letterSpacing: 0.4,
                                    fontFamily: robottoFontTextStyle),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        Row(
                          children: [
                            Text(
                              "Log in",
                              style: headingTextStyle.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 32.h,
                        ),

                        ///
                        /// ========= Login Form Section =========
                        ///

                        Form(
                          key: _formKey,
                          child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ///
                              /// email name field
                              ///
                              CustomTextField(
                                  controller: model.emailController,
                                  onTap: () {},
                                  validator: (val) {
                                    if (!val.toString().trim().isEmail) {
                                      return 'Please Enter a Valid Email';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) {
                                    model.customerUser.email = val;
                                  },
                                  hintText: "Email",
                                  prefixIcon: Container()
                                  // Icon(Icons.person)
                                  //  ImageContainer(
                                  //   width: 22.w,
                                  //   height: 22.h,
                                  //   assets:
                                  //       "${staticAssetsPath}user_field_icon.png",
                                  //   fit: BoxFit.contain,
                                  // ),
                                  ),

                              SizedBox(
                                height: 24,
                              ),

                              ///
                              /// Password field
                              ///
                              CustomTextField(
                                obscure: _passwordVisible,
                                validator: (val) {
                                  if (val.length < 1) {
                                    return 'Please enter your password';
                                  } else if (val.length < 8) {
                                    return 'Password must include 8 characters';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: model.passwordController,
                                onTap: () {},
                                onSaved: (val) {
                                  model.customerUser.password = val;
                                },
                                // label: "Password",
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                // prefixIcon: Icon(Icons.password)
                                // ImageContainer(
                                //   width: 22.w,
                                //   height: 22.h,
                                //   assets:
                                //       "${staticAssetsPath}pasword_field_icon.png",
                                //   fit: BoxFit.contain,
                                // ),
                              ),

                              SizedBox(
                                height: 16.h,
                              ),
                              RoundedRaisedButton(
                                textColor: Colors.white,
                                onPressed: () async {
                                  // Get.to(() => RootProviderScreen());
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    await model.loginWithEmailPassword();

                                    if (model.status) {
                                      print("Login Customer Successfully");
                                      Get.offAll(() => RootSCustomercreen());
                                    } else {
                                      Get.dialog(RequestFailedDialog(
                                        errorMessage: model.errorMessage,
                                      ));
                                    }
                                  }
                                },
                                buttonText: "LOG IN",
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => SignUpCustomerScreen());
                                },
                                child: Text(
                                  "Don’t have an account yet  SignUp?",
                                  style: bodyTextStyle.copyWith(
                                      fontFamily: robottoFontTextStyle,
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      letterSpacing: 0.4,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
