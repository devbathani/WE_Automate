import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/conversation/customer-conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/order_list.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/customer_search_services_screen.dart';
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
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, top: 40.h, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Color(0xff8B53FF),
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80.h,
            ),
            InkWell(
              onTap: () {
                Get.to(
                  () => CustomerSearchServicesScreen(),
                );
              },
              child: Container(
                height: 70.h,
                width: 380.w,
                decoration: BoxDecoration(
                  color: Color(0xff8B53FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Image.asset(
                        "$static_assets/homescreen_1.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "Book a Service",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () {
                Get.to(
                  () => OrderList(),
                );
              },
              child: Container(
                height: 70.h,
                width: 380.w,
                decoration: BoxDecoration(
                  color: Color(0xff8B53FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Image.asset(
                        "$static_assets/homescreen_2.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "My Bookings",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () {
                Get.to(
                  () => CustomerConversationScreen(),
                );
              },
              child: Container(
                height: 70.h,
                width: 380.w,
                decoration: BoxDecoration(
                  color: Color(0xff8B53FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Image.asset(
                        "$static_assets/homescreen_3.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "My Messages",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
