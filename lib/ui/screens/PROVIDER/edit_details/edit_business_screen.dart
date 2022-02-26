import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/custom_text_field.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/edit_details/edit_business_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:antonx_flutter_template/core/constants/text_styles.dart';

import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
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
                  children: [
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
                          "Edit Business Details",
                          style: headingTextStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 25.sp,
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
                              // controller: model.emailController,
                              onTap: () {},
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
                              prefixIcon: Container()),

                          // CustomTextField(
                          //     // controller: model.emailController,
                          //     onTap: () {},
                          //     validator: (val) {
                          //       if (!val.toString().trim().isEmail) {
                          //         return 'Please Enter a Valid Email';
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     onSaved: (val) {
                          //       appUser.email = val;
                          //     },
                          //     hintText: "Email",
                          //     prefixIcon: Container(),
                          //     ),

                          SizedBox(
                            height: 24,
                          ),

                          CustomTextField(
                              // controller: model.emailController,
                              onTap: () {},
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
                              prefixIcon: Container()),

                          SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                              maxline: 5,
                              // controller: model.emailController,
                              onTap: () {},
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
                              prefixIcon: Container()),

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
                            // controller: model.emailController,
                            onTap: () {},
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
                            prefixIcon: Container(),
                          ),

                          SizedBox(
                            height: 43.h,
                          ),
                          Container(
                            height: 26.h,
                            width: 184.w,
                            child: RoundedRaisedButton(
                                buttonText: "Edit Details",
                                textColor: primaryColor,
                                color: Colors.white,
                                onPressed: () async {
                                  print(":");
                                  isLoading = true;
                                  setState(() {});
                                  Future.delayed(
                                    Duration(seconds: 3),
                                    () async {
                                      isLoading = false;
                                      setState(() {});
                                      await model
                                          .updateBusinessDetails(appUser);
                                      Get.back(result: model);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "The service has been booked successfully",
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
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
