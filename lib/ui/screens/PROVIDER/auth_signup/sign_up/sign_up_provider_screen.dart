import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/custom_text_field.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/home/pdf_view_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/strings.dart';
import '../../../../custom_widgets/dailogs/request_failed_dailog.dart';
import '../../root/root-provider-screen.dart';
import '../provider_auth_view_model.dart';

class SignUpProviderScreen extends StatefulWidget {
  //Todo: Do localization here.
  @override
  _SignUpProviderScreenState createState() => _SignUpProviderScreenState();
}

class _SignUpProviderScreenState extends State<SignUpProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isOther = false;
  bool _isBipoc = false;
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
    return Consumer<ProviderAuthViewModel>(
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
                            hintText: "Name of Business",
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return 'Invalid Field';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              model.providerUser.businessName = value;
                            },
                          ),
                          SizedBox(
                            height: 20.h,
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
                              model.providerUser.email = val;
                            },
                            hintText: "Email",
                          ),
                          SizedBox(
                            height: 20.h,
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
                                model.providerUser.password = val;
                              },
                              hintText: "Password"),
                          SizedBox(
                            height: 20.h,
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
                              model.providerUser.typeOfBusiness = val;
                            },
                            hintText: "Type of business",
                          ),
                          SizedBox(
                            height: 20.h,
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
                              model.providerUser.description = val;
                            },
                            hintText: "Short Description / History",
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: _isBipoc,
                                  onChanged: (value) {
                                    _isBipoc = value!;
                                    model.providerUser.isBipoc = value;
                                    setState(() {});
                                  }),
                              Text(
                                "BIPOC owned",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black),
                                  value: _isOther,
                                  onChanged: (value) {
                                    _isOther = value!;
                                    model.providerUser.isOther = value;
                                    setState(() {});
                                  }),
                              Text(
                                "Other-",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          CustomTextField(
                            obscureText: false,
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return 'Invalid Field';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) {
                              model.providerUser.address = val;
                            },
                            hintText: "Address",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            model.providerUser.createdAt =
                                DateTime.now().toString();
                            model.providerUser.fcmToken = fcmToken;
                            // Get.to(() => RootProviderScreen());
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await model.createAccount();
                              if (model.status) {
                                print("SignUp Successfully");
                                Get.offAll(() => RootProviderScreen());
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                      child: SizedBox(
                        width: 300.w,
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "By signing up, you agree to ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17.sp,
                                  ),
                                ),
                                TextSpan(
                                    text: "Terms of Service & ",
                                    style: TextStyle(
                                      color: Color(0XFF1b77f2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.sp,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(
                                          () => PdfViewers(
                                            document: "assets/terms.pdf",
                                          ),
                                        );
                                      }),
                                TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      color: Color(0XFF1b77f2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.sp,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(
                                          () => PdfViewers(
                                            document: "assets/privacy.pdf",
                                          ),
                                        );
                                      }),
                              ],
                            ),
                          ),
                        ),
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
