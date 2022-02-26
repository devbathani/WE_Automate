import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/custom_text_field.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/root/root-provider-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customer_auth_view_model.dart';

class SignUpCustomerScreen extends StatelessWidget {
  //Todo: Do localization here.
  final _formKey = GlobalKey<FormState>();
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
                                assets: "$assets/back.png",
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
                              "Register",
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
                              /// business name field
                              ///
                              CustomTextField(
                                  onTap: () {},
                                  validator: (val) {
                                    if (val.toString().trim().isEmpty) {
                                      return 'Invalid Field';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) {
                                    model.customerUser.firstName = val;
                                  },
                                  hintText: "Name",
                                  prefixIcon: Container()),

                              SizedBox(
                                height: 24,
                              ),
                              CustomTextField(
                                  onTap: () {},
                                  validator: (val) {
                                    if (val.toString().trim().isEmpty) {
                                      return 'Invalid Field';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) {
                                    model.customerUser.lastName = val;
                                  },
                                  hintText: "Last Name",
                                  prefixIcon: Container()),

                              SizedBox(
                                height: 24,
                              ),
                              CustomTextField(
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
                                  prefixIcon: Container()),

                              SizedBox(
                                height: 24,
                              ),

                              ///
                              /// Password field
                              ///
                              CustomTextField(
                                  obscure: model.passwordVisibility,
                                  validator: (val) {
                                    if (val.length < 1) {
                                      return 'Please enter your password';
                                    } else if (val.length < 8) {
                                      return 'Password must include 8 characters';
                                    } else {
                                      return null;
                                    }
                                  },
                                  // controller: modela.passwordController,
                                  onTap: () {},
                                  onSaved: (val) {
                                    model.customerUser.password = val;
                                  },
                                  hintText: "Password"),
                              SizedBox(
                                height: 24,
                              ),

                              ///
                              /// Password field
                              ///
                              CustomTextField(
                                  inputType: TextInputType.number,
                                  onTap: () {},
                                  validator: (val) {
                                    if (val.toString().trim().isEmpty) {
                                      return 'Invalid Field';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) {
                                    model.customerUser.phoneNumber = val;
                                  },
                                  hintText: "Phone Number",
                                  prefixIcon: Container()),

                              SizedBox(
                                height: 24,
                              ),

                              CustomTextField(
                                  onTap: () {},
                                  validator: (val) {
                                    if (val.toString().trim().isEmpty) {
                                      return 'Invalid Field';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (val) {
                                    model.customerUser.address = val;
                                  },
                                  hintText: "Address",
                                  prefixIcon: Container()),

                              SizedBox(
                                height: 43.h,
                              ),
                              RoundedRaisedButton(
                                textColor: Colors.white,
                                onPressed: () async {
                                  model.customerUser.createdAt =
                                      DateTime.now().toString();
                                  // Get.to(() => RootProviderScreen());
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    await model.createAccount();
                                    if (model.status) {
                                      print("SignUp Successfully");
                                      Get.offAll(() => RootSCustomercreen());
                                    } else {
                                      Get.dialog(RequestFailedDialog(
                                        errorMessage: model.errorMessage,
                                      ));
                                    }
                                  }
                                },
                                buttonText: "SIGN UP",
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            "By signing up, you agree to Photo’s ",
                                        style: bodyTextStyle.copyWith(
                                            fontFamily: robottoFontTextStyle,
                                            fontSize: 13.sp,
                                            color: Colors.black,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: "Terms of Service",
                                        style: bodyTextStyle.copyWith(
                                            fontFamily: robottoFontTextStyle,
                                            fontSize: 13.sp,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.black,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: " and ",
                                        style: bodyTextStyle.copyWith(
                                            fontFamily: robottoFontTextStyle,
                                            fontSize: 13.sp,
                                            color: Colors.black,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: "Privacy Policy.",
                                        style: bodyTextStyle.copyWith(
                                            fontFamily: robottoFontTextStyle,
                                            fontSize: 13.sp,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ]),
                                  )),
                              //   Text(
                              //     "By signing up, you agree to Photo’s Terms of Service and\nPrivacy Policy.",
                              //   style: bodyTextStyle.copyWith(
                              //       fontFamily: robottoFontTextStyle,
                              //       fontSize: 13.sp,
                              //       color: Colors.black,
                              //       letterSpacing: 0.4,
                              //       fontWeight: FontWeight.normal),
                              //   textAlign: TextAlign.left,
                              // ),
                              // ),
                              SizedBox(
                                height: 100.h,
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
