import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../custom_widgets/dailogs/request_failed_dailog.dart';
import '../../root/root-provider-screen.dart';
import '../provider_auth_view_model.dart';
import '../sign_up/sign_up_provider_screen.dart';

class LoginProviderScreen extends StatefulWidget {
  //Todo: Do localization here.
  @override
  _LoginProviderScreenState createState() => _LoginProviderScreenState();
}

class _LoginProviderScreenState extends State<LoginProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final h = Get.height;
  final w = Get.width;
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
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
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
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: TextFormField(
                              controller: model.emailController,
                              validator: (val) {
                                if (!val.toString().isEmail) {
                                  return 'Please Enter a Valid Email';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                model.providerUser.email = val;
                              },
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: w / 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 15.h,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff8B53FF),
                                    width: 7,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff8B53FF),
                                    width: 7,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                hintText: 'Email',
                                hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: TextFormField(
                              validator: (val) {
                                if (val!.length < 1) {
                                  return 'Please enter your password';
                                } else if (val.length < 8) {
                                  return 'Password must include 8 characters';
                                } else {
                                  return null;
                                }
                              },
                              controller: model.passwordController,
                              onSaved: (val) {
                                model.providerUser.password = val;
                              },
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: w / 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 15.h,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff8B53FF),
                                    width: 7,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff8B53FF),
                                    width: 7,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                hintText: 'Password',
                                hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              await model.loginWithEmailPassword();

                              if (model.status) {
                                print("Login Successfully");
                                Get.offAll(() => RootProviderScreen());
                              } else {
                                Get.dialog(RequestFailedDialog(
                                  errorMessage: model.errorMessage,
                                ));
                              }
                            }
                          },
                          child: Container(
                            height: 70.h,
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
                                    width: 60.w,
                                  ),
                                  Image.asset(
                                    "$assets/female.png",
                                    height: 50.h,
                                    width: 50.w,
                                  ),
                                  SizedBox(
                                    width: 20.w,
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
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => SignUpProviderScreen());
                          },
                          child: Text(
                            "Don’t have an account yet, Signup?",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
