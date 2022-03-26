import 'dart:developer';

import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/customer_search_services_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/detail/customer_search_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../locator.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      ///
      ///FAB
      ///
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => RootSCustomercreen(index: 2));
        },
        child: ImageContainer(
          assets: "$assets/fab0.png",
          height: 60.h,
          width: 60.w,
          fit: BoxFit.cover,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, top: 40.h, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Wrap(
              children: [
                Text(
                  "Welcome",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "${locator<AuthService>().customerProfile!.firstName}",
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Color.fromARGB(221, 55, 82, 238),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => CustomerSearchServicesScreen(),
                    );
                  },
                  child: Container(
                    height: 100.h,
                    width: 166.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: Color(0XFFf4f4f4),
                    ),
                    child: Center(
                      child: Text(
                        'Book a service',
                        style: GoogleFonts.poppins(fontSize: 17.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                InkWell(
                  onTap: () {
                    log("Button is disabled");
                    // Get.to(
                    //   () => CustomerSearchDetailScreen(),
                    // );
                  },
                  child: Container(
                    height: 100.h,
                    width: 166.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: Color(0XFF262626),
                    ),
                    child: Center(
                      child: Text(
                        'Buy Products',
                        style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Upcoming Services',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18.sp),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5.h),
                        height: 30.h,
                        width: 40.w,
                        child: Center(
                          child: Image.asset('assets/static_assets/upcoming_services.jpg'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Color(0XFFf4f4f4),
                          image:
                              DecorationImage(image: AssetImage('assets/static_assets/image1.jpg'), fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.r),
                            bottomRight: Radius.circular(20.r),
                            topLeft: Radius.circular(45.r),
                            bottomLeft: Radius.circular(10.r),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          image:
                              DecorationImage(image: AssetImage('assets/static_assets/image4.jpg'), fit: BoxFit.fill),
                          color: Color(0XFFf4f4f4),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(45.r),
                            bottomRight: Radius.circular(20.r),
                            topLeft: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          image:
                              DecorationImage(image: AssetImage('assets/static_assets/image3.jpg'), fit: BoxFit.cover),
                          color: Color(0XFFf4f4f4),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.r),
                            bottomRight: Radius.circular(20.r),
                            topLeft: Radius.circular(45.r),
                            bottomLeft: Radius.circular(10.r),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          image:
                              DecorationImage(image: AssetImage('assets/static_assets/image2.jpeg'), fit: BoxFit.cover),
                          color: Color(0XFFf4f4f4),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(45.r),
                            bottomRight: Radius.circular(20.r),
                            topLeft: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
