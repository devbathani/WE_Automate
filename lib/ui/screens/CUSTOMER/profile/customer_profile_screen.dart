import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/order_list.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/provider_auth_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/common_ui/select_user_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';
import '../conversation/customer-conversation-screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatarArea(context),
            buttonsArea(context),
          ],
        ),
      ),
    );
  }

  avatarArea(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100.h,
          ),
          Text(
            "Welcome",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black87,
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Text(
            "${locator<AuthService>().customerProfile!.firstName}",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color(0xff8B53FF),
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buttonsArea(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.h),
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
          InkWell(
            onTap: () {
              Provider.of<ProviderAuthViewModel>(context, listen: false)
                  .logout();
              Get.offAll(() => SelectUserTypeScreen());
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
                      "$static_assets/logout.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      "Logout",
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
        ],
      ),
    );
  }
}
