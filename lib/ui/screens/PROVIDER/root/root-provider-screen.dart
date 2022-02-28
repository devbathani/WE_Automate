import 'dart:io';

import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/customer_search_services_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/home/home_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/products/add_products/add-product-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/profile/provider-profile-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/search/detail/provider_search_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///
///This is a [root-screen] of app for integrating the bottom-navigation bar and showing other screens
///
class RootProviderScreen extends StatefulWidget {
  final int index;
  RootProviderScreen({this.index = 0});
  @override
  _RootProviderScreenState createState() => _RootProviderScreenState();
}

class _RootProviderScreenState extends State<RootProviderScreen> {
  /// or accessing selected bottom navigation bar item
  var selectedIndex = 0;

  ///for putting a list of screens to bottom naviagtion bar childrens
  List<Widget> bottomAppBarScreens = <Widget>[
    HomeScreen(),
    ProviderSearchDetailScreen(),
    AddProductScreen(isBottom: true),
    ConversationScreen(),
    ProviderProfileScreen()
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
                  color: Colors.grey.withOpacity(1),
                  blurRadius: 1, // has the effect of softening the shadow
                  spreadRadius: 0, // has the effect of extending the shadow
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
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius: BorderRadius.circular(50),
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
                  ),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius: BorderRadius.circular(50),
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
                  ),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          _onItemTapped(2);
                        },
                        child: ImageContainer(
                          assets: selectedIndex == 2
                              ? "assets/static_assets/bottom-nav-bar/add_b.png"
                              : "assets/static_assets/bottom-nav-bar/add_b.png",
                          height: 50.h,
                          width: 70.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          _onItemTapped(3);
                        },
                        child: ImageContainer(
                          assets: selectedIndex == 3
                              ? "assets/static_assets/bottom-nav-bar/comment.png"
                              : "assets/static_assets/bottom-nav-bar/comment.png",
                          height: 50.h,
                          width: 50.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      // padding: EdgeInsets.zero,
                      child: InkWell(
                        splashColor: Colors.green,
                        // radius: 5.r,
                        borderRadius: BorderRadius.circular(50),
                        // splashColor: Colors.red,
                        onTap: () {
                          _onItemTapped(4);
                        },
                        child: ImageContainer(
                          assets: selectedIndex == 4
                              ? "assets/static_assets/bottom-nav-bar/user.png"
                              : "assets/static_assets/bottom-nav-bar/user.png",
                          height: 50.h,
                          width: 50.w,
                          fit: BoxFit.contain,
                        ),
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
