import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/order_list.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/provider_auth_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/common_ui/select_user_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(() => RootSCustomercreen(index: 2));
        },
        child: ImageContainer(
          assets: "$assets/fab0.png",
          height: 60.h,
          width: 60.w,
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///avatar user one area
            ///
            avatarArea(context),

            buttonsArea(context),

            // ratings(),
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
            "Hey there..",
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
                color: Color.fromARGB(221, 55, 82, 238),
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
              print(":");
              Get.offAll(() => RootSCustomercreen(index: 2));
            },
            child: Container(
              height: 60.h,
              width: 350.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent, Colors.orange],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade400,
                    offset: Offset(4, 4),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print(":");
                        Get.offAll(() => RootSCustomercreen(index: 2));
                      },
                      icon: Icon(Icons.message),
                      iconSize: 25.w,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Text(
                      "My Messages",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          InkWell(
            onTap: () {
              print(":");
              Get.to(OrderList());
            },
            child: Container(
              height: 60.h,
              width: 350.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightGreen,
                    Colors.green,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade400,
                    offset: Offset(4, 4),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print(":");
                        Get.to(OrderList());
                      },
                      icon: Icon(
                        Icons.link,
                      ),
                      iconSize: 25.w,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Text(
                      "My Bookings",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
          InkWell(
            onTap: () {
              Provider.of<ProviderAuthViewModel>(context, listen: false)
                  .logout();
              Get.offAll(() => SelectUserTypeScreen());
            },
            child: Container(
              height: 60.h,
              width: 350.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent,
                    Colors.red,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade400,
                    offset: Offset(4, 4),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Provider.of<ProviderAuthViewModel>(context,
                                listen: false)
                            .logout();
                        Get.offAll(() => SelectUserTypeScreen());
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                      iconSize: 25.w,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
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

  ratings() {
    return Padding(
      padding: EdgeInsets.only(top: 44.h, bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "RATING",
            style: headingTextStyle.copyWith(
                fontSize: 13.sp, fontFamily: robottoFontTextStyle),
          ),
          SizedBox(width: 23.0.w),
          RatingBarIndicator(
            rating: 0, //2.75,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            unratedColor: Colors.grey.withOpacity(0.5),
            itemCount: 5,
            itemPadding: EdgeInsets.only(right: 6.w),
            itemSize: 26.0,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
