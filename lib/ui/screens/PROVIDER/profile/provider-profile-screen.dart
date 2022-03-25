import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/booking/booking-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/edit_details/edit_business_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/profile/provider-profile-view-model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/root/root-provider-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/webview/webview-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderProfileViewModel(),
      child: Consumer<ProviderProfileViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ///avatar user one area
                  avatarArea(),
                  buttonsArea(),

                  // ratings(),

                  galleryView(model),
                  model.services.length < 5 && model.state == ViewState.idle ? Container() : seeMoreButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  seeMoreButton() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 50.h, bottom: 40),
      child: Container(
          height: 54.h,
          child: RoundedRaisedButton(
              buttonText: "SEE MORE", color: Colors.white, textColor: primaryColor, onPressed: () {})),
    );
  }

  avatarArea() {
    return Column(
      children: [
        SizedBox(
          height: 80.h,
        ),
        ImageContainer(
          assets: "$assets/avatar.png",
          height: 128.h,
          width: 128.w,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 13.h,
        ),
        Text(
          "Provider",
          style: bodyTextStyle.copyWith(
            fontSize: 36.sp,
          ),
        ),
        SizedBox(
          height: 10.h,
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
                  style: headingTextStyle.copyWith(height: 1.6, fontSize: 13.sp, fontFamily: robottoFontTextStyle),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Text(
          "${locator<AuthService>().providerProfile!.businessName!}".toUpperCase(),
          style: headingTextStyle.copyWith(fontSize: 13.sp, fontFamily: robottoFontTextStyle),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  buttonsArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 26.h,
            width: 184.w,
            child: RoundedRaisedButton(
                buttonText: "WEBSITE",
                textColor: primaryColor,
                color: Colors.white,
                onPressed: () {
                  print(":");

                  Get.to(() => WebviewScreen());
                }),
          ),
        ]),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "My MESSAGES",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");

                    Get.offAll(() => RootProviderScreen(index: 3));
                  }),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "My BOOKINGS",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");

                    Get.to(() => BookingScreen());
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 26.h,
            width: 184.w,
            child: RoundedRaisedButton(
                buttonText: "Edit Details",
                textColor: primaryColor,
                color: Colors.white,
                onPressed: () {
                  print(":");

                  Get.to(
                    () => EditDetailsScreen(),
                  );
                }),
          ),
        ]),
      ],
    );
  }

  ratings() {
    return Padding(
      padding: const EdgeInsets.only(top: 33, bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "RATING",
            style: headingTextStyle.copyWith(fontSize: 13, fontFamily: robottoFontTextStyle),
          ),
          SizedBox(width: 5.0.w),
          RatingBarIndicator(
            rating: 5, //2.75,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemPadding: EdgeInsets.only(right: 3.w),
            itemSize: 26.0,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }

  galleryView(ProviderProfileViewModel model) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 22, right: 22.0),
            child: model.services.length >= 1 && model.state == ViewState.idle
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 280.h, crossAxisSpacing: 10),
                    itemCount: (model.services.length),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Text("title"),
                              Text("${model.services[index].title}"),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, right: 10),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 250.h,
                                      width: 1.sw / 2.4,
                                      child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholder: '$assets/placeholder.jpeg',
                                          image: model.services[index].imgUrl!),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12, right: 12, bottom: 250.h - 40.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 24.h,
                                            width: 24.w,
                                            decoration: BoxDecoration(
                                                color: model.services[index].availability == "Available"
                                                    ? Color(0XFF0ACF83)
                                                    : model.services[index].availability == "Available soon"
                                                        ? Color(0XFFFBF90A)
                                                        : Colors.red,
                                                shape: BoxShape.circle),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () {},
                                          //   child: Container(
                                          //     height: 36.h,
                                          //     width: 36.w,
                                          //     decoration: BoxDecoration(
                                          //         shape: BoxShape.circle,
                                          //         color: Colors.white),
                                          //     child: Icon(Icons.edit, size: 18),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 0),
                                        child: Container(
                                          height: 76.h,
                                          // width:1.
                                          color: Colors.black26,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    Text("Desc: ${model.services[index].description}",
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: headingTextStyle.copyWith(
                                                                          fontSize: 12.sp,
                                                                          color: Colors.white,
                                                                        )),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text("Price: ${model.services[index].price} usd",
                                                              // "Price: 50 usd",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: headingTextStyle.copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors.white,
                                                              )),
                                                          SizedBox(height: 4.h),
                                                          Text("Cat: ${model.services[index].category}",
                                                              // "Price: 50 usd",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: headingTextStyle.copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors.white,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    })
                : Center(
                    child: Text("No service available"),
                  )),
        SizedBox(height: 100)
      ],
    );
  }
}
