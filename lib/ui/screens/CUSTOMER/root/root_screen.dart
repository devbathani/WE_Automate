import 'dart:io';

import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/conversation/customer-conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/home_screens/home_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/profile/customer_profile_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/customer_search_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    // CustomerProfileScreen(),
    CustomerSearchServicesScreen(
      isBottom: true,
    ),
    // Scaffold(
    //     body: Center(
    //   child: Text("2"),
    // )),
    CustomerConversationScreen(
      isBottom: true,
    ),
    CustomerProfileScreen(),
    // MyCartScreen(),
    // NotificationScreen(),
    // MyProfileScreen()
    // Scaffold(
    //     body: Center(
    //   child: Text("1"),
    // )),
    // Scaffold(
    //     body: Center(
    //   child: Text("2"),
    // )),
    // Scaffold(
    //     body: Center(
    //   child: Text("3"),
    // )),
    // Scaffold(
    //     body: Center(
    //   child: Text("4"),
    // )),
    // Scaffold(
    //     body: Center(
    //   child: Text("5"),
    // )),
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

        ///
        ///passing my all [screens] in root screen body
        ///
        body: bottomAppBarScreens.elementAt(selectedIndex),

        ///
        ///[BNB] bottom navigation bar for multiple screen access from dashboard
        ///
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: 72.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8, // has the effect of softening the shadow
                  spreadRadius: 1.2, // has the effect of extending the shadow
                  offset: Offset(
                    0, // horizontal, move right 10
                    0, // vertical, move down 10
                  ),
                )
              ],
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(
              //       30.0,
              //     ),
              //     topRight: Radius.circular(
              //       30.0,
              // )
              // )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: ImageContainer(
                        assets: selectedIndex == 0
                            ? "assets/static_assets/bottom-nav-bar/home.png"
                            : "assets/static_assets/bottom-nav-bar/home.png",
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: ImageContainer(
                        assets: selectedIndex == 1
                            ? "assets/static_assets/bottom-nav-bar/search.png"
                            : "assets/static_assets/bottom-nav-bar/search.png",
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       _onItemTapped(2);
                  //     },
                  //     child: ImageContainer(
                  //       assets: selectedIndex == 2
                  //           ? "assets/static_assets/bottom-nav-bar/add_b.png"
                  //           : "assets/static_assets/bottom-nav-bar/add_b.png",
                  //       height: 50.h,
                  //       width: 70.w,
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onItemTapped(2);
                      },
                      child: ImageContainer(
                        assets: selectedIndex == 2
                            ? "assets/static_assets/bottom-nav-bar/comment.png"
                            : "assets/static_assets/bottom-nav-bar/comment.png",
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _onItemTapped(3);
                      },
                      child: ImageContainer(
                        assets: selectedIndex == 3
                            ? "assets/static_assets/bottom-nav-bar/user.png"
                            : "assets/static_assets/bottom-nav-bar/user.png",
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  ///on[ backpressed] call back to avoid user interaction with splash screen
  ///
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
    // if (index == 2) {
    // } else {
    setState(() {
      selectedIndex = index;
    });
    // }
  }
}
