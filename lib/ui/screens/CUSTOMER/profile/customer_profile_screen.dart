import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/order_list.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/customer_search_services_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/search/detail/customer_search_detail_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/provider_auth_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/common_ui/select_user_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
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
          children: [
            ///avatar user one area
            ///
            avatarArea(),

            buttonsArea(),

            ratings(),
          ],
        ),
      ),
    );
  }

  avatarArea() {
    return Column(
      children: [
        SizedBox(
          height: 40.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Provider.of<ProviderAuthViewModel>(context, listen: false)
                      .logout();
                  Get.offAll(() => SelectUserTypeScreen());
                },
                icon: Icon(Icons.logout)),
            SizedBox(
              width: 20.w,
            )
          ],
        ),
        ImageContainer(
          assets: "$assets/avatar03.png",
          height: 128.h,
          width: 128.w,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 32.h,
        ),
        Text(
          "${locator<AuthService>().customerProfile!.firstName}",
          // "Ben",
          style: bodyTextStyle.copyWith(
            fontSize: 36.sp,
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "${locator<LocationService>().address}".toUpperCase(),
                  // "Toronto, CA".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: headingTextStyle.copyWith(
                      height: 1.6,
                      fontSize: 13.sp,
                      fontFamily: robottoFontTextStyle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buttonsArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 64.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 26.h,
            width: 172.w,
            child: RoundedRaisedButton(
                buttonText: "MESSAGE",
                textColor: primaryColor,
                color: Colors.white,
                onPressed: () {
                  print(":");
                  Get.offAll(() => RootSCustomercreen(index: 2));
                }),
          ),
        ]),
        SizedBox(
          height: 28.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "FIND SERVICES/PRODUCTS",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");

                    Get.to(() => CustomerSearchServicesScreen());
                  }),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "BUY PRODUCTS",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");

                    Get.to(() => CustomerSearchDetailScreen());
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 28.h,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 26.h,
            width: 172.w,
            child: RoundedRaisedButton(
                buttonText: "BOOKINGS",
                textColor: primaryColor,
                color: Colors.white,
                onPressed: () {
                  print(":");
                  Get.to(OrderList());
                }),
          ),
        ]),
      ],
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
