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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Image.asset(
            '$assets/app_icon.png',
            height: 300.h,
            width: 300.w,
          ),
          SizedBox(height: 50.h),
          Text(
            "How can we help you today?".toUpperCase(),
            style: headingTextStyle.copyWith(
                fontSize: 18.sp,
                fontFamily: robottoFontTextStyle,
                color: Colors.black),
          ),
          SizedBox(height: 27.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 26.h,
                width: 131.w,
                child: RoundedRaisedButton(
                  buttonText: "Book a service".toUpperCase(),
                  textColor: Colors.white,
                  color: Color(0XFF3B62EE),
                  onPressed: () {
                    print(":");
                    Get.to(
                      () => CustomerSearchServicesScreen(),
                    );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: 26.h,
                width: 149.w,
                child: RoundedRaisedButton(
                  buttonText: "Make a purchase".toUpperCase(),
                  textColor: primaryColor,
                  color: Color(0XFFFBF90A),
                  onPressed: () {
                    print(":");

                    Get.to(
                      () => CustomerSearchDetailScreen(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
