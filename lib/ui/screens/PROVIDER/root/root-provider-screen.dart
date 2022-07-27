import 'dart:io';

import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/home/home_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/profile/provider-profile-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/strings.dart';

class RootProviderScreen extends StatefulWidget {
  final int index;
  RootProviderScreen({this.index = 0});
  @override
  _RootProviderScreenState createState() => _RootProviderScreenState();
}

class _RootProviderScreenState extends State<RootProviderScreen> {
  var selectedIndex = 0;
  List<Widget> bottomAppBarScreens = <Widget>[
    HomeScreen(),
    ProviderProfileScreen(),
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
                          color: Color(0XFF1b77f2),
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '$static_assets/Home.png',
                              height: 40.h,
                              width: 40.w,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Home",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w300,
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
                          color: Color(0XFF1b77f2),
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '$static_assets/profile.png',
                              height: 40.h,
                              width: 40.w,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Profile",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
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
            new TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                // _updateConnectionFlag(true);
              },
              child: Text("NO",
                  style: bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: Colors.red,
                  )),
            ),
            SizedBox(height: 16),
            new TextButton(
              onPressed: () {
                exit(0);
              },
              child: Text("YES",
                  style: bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: Colors.black,
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
