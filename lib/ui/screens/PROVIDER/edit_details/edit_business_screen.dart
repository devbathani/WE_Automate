import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/custom_text_field.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/edit_details/edit_business_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:get/get.dart';

class EditDetailsScreen extends StatefulWidget {
  const EditDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isOther = false;
  bool _isBipoc = false;
  AppUser appUser = AppUser();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), () {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => EditBusinessDetialViewModel(),
        child: Consumer<EditBusinessDetialViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 50.h,
                horizontal: 15.w,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
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
                      height: 26.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Edit Business Details",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Color(0xff8B53FF),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                              appUser.businessName = val;
                            },
                            hintText: "Name of business",
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
                              appUser.email = val;
                            },
                            hintText: "Email",
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
                              appUser.typeOfBusiness = val;
                            },
                            hintText: "Type of business",
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
                              appUser.description = val;
                            },
                            hintText: "Description / History",
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: _isBipoc,
                                      onChanged: (value) {
                                        _isBipoc = value!;
                                        appUser.isBipoc = value;
                                        setState(() {});
                                      }),
                                  Text(
                                    "BIPOC owned",
                                    style: bodyTextStyle.copyWith(
                                        fontFamily: robottoFontTextStyle,
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.normal),
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
                                        appUser.isOther = value;
                                        setState(() {});
                                      }),
                                  Text(
                                    "Other-",
                                    style: bodyTextStyle.copyWith(
                                        fontFamily: robottoFontTextStyle,
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 24,
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
                              appUser.address = val;
                            },
                            hintText: "Address",
                          ),
                          SizedBox(
                            height: 43.h,
                          ),
                          InkWell(
                            onTap: () {
                              print(":");
                              isLoading = true;
                              setState(() {});
                              Future.delayed(
                                Duration(seconds: 3),
                                () async {
                                  isLoading = false;
                                  setState(() {});
                                  await model.updateBusinessDetails(appUser);
                                  Get.back(result: model);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "The service has been booked successfully",
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 60.h,
                              width: 250.w,
                              decoration: BoxDecoration(
                                color: Color(0XFF8B53FF),
                                borderRadius: BorderRadius.circular(13.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Edit Details",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
