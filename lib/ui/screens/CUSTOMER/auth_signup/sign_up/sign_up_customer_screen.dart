import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/custom_text_field.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customer_auth_view_model.dart';

class SignUpCustomerScreen extends StatefulWidget {
  @override
  State<SignUpCustomerScreen> createState() => _SignUpCustomerScreenState();
}

class _SignUpCustomerScreenState extends State<SignUpCustomerScreen> {
  //Todo: Do localization here.
  final _formKey = GlobalKey<FormState>();
  String fcmToken = '';
  void getToken() async {
    final tokens = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = tokens!;
    });
    print('Your FCM TOKEN IS ::::::::::::>' + tokens!);
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerAuthViewModel>(
      builder: (context, model, child) => ModalProgressHUD(
        inAsyncCall: model.state == ViewState.busy,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Back",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        "Register",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            obscureText: false,
                            hintText: 'Name',
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
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                            obscureText: false,
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
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                            obscureText: false,
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
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                            obscureText: model.passwordVisibility,
                            validator: (val) {
                              if (val!.length < 1) {
                                return 'Please enter your password';
                              } else if (val.length < 8) {
                                return 'Password must include 8 characters';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) {
                              model.customerUser.password = val;
                            },
                            hintText: "Password",
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                            obscureText: false,
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
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                            obscureText: false,
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
                          ),
                          SizedBox(
                            height: 43.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  model.customerUser.createdAt =
                                      DateTime.now().toString();
                                  model.customerUser.fcmToken = fcmToken;
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
                                child: Container(
                                  height: 60.h,
                                  width: 350.w,
                                  decoration: BoxDecoration(
                                    color: Color(0XFF1b77f2),
                                    borderRadius: BorderRadius.circular(13.r),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "$assets/register.png",
                                          height: 50.h,
                                          width: 50.w,
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Text(
                                          "SIGN UP",
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
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "By signing up, you agree to Terms of Service and Privacy Policy",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
