import 'dart:io';

import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/home_screens/home_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/profile/customer_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

///
///This is a [root-screen] of app for integrating the bottom-navigation bar and showing other screens
///
class RootSCustomercreen extends StatefulWidget {
  final int index;
  RootSCustomercreen({this.index = 0});
  @override
  _RootSCustomercreenState createState() => _RootSCustomercreenState();
}

class _RootSCustomercreenState extends State<RootSCustomercreen> {
  /// or accessing selected bottom navigation bar item
  var selectedIndex = 0;

  ///for putting a list of screens to bottom naviagtion bar childrens
  List<Widget> bottomAppBarScreens = <Widget>[
    CustomerHomeScreen(),
    CustomerProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: bottomAppBarScreens.elementAt(selectedIndex),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Container(
                width: double.infinity,
                height: 72.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: Container(
                        height: 70.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: Color(0xff8B53FF),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                '$static_assets/Home.png',
                                height: 60.h,
                                width: 60.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Home",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: Container(
                        height: 70.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: Color(0xff8B53FF),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                '$static_assets/female.png',
                                height: 50.h,
                                width: 50.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Profile",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
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
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await Get.defaultDialog(
          title: 'Are you sure?',
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new FlatButton(
              textColor: primaryColor,
              onPressed: () {
                Navigator.of(context).pop(false);
                // _updateConnectionFlag(true);
              },
              child: Text("NO",
                  style: bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    // color: Colors.white,
                  )),
            ),
            SizedBox(height: 16),
            new FlatButton(
              textColor: Colors.white,
              color: primaryColor,
              onPressed: () {
                exit(0);
              },
              child: Text("YES",
                  style: bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: Colors.white,
                  )),
            ),
          ],
        ) ??
        false;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
