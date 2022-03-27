import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/edit_details/edit_business_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/profile/provider-profile-view-model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/webview/webview-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';
import '../../common_ui/select_user_type_screen.dart';
import '../auth_signup/provider_auth_view_model.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///avatar user one area
                  avatarArea(context),
                  buttonsArea(context),

                  //ratings(),

                  // galleryView(model),
                  // model.services.length < 5 && model.state == ViewState.idle
                  //     ? Container()
                  //     : seeMoreButton(),
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
              buttonText: "SEE MORE",
              color: Colors.white,
              textColor: primaryColor,
              onPressed: () {})),
    );
  }

  avatarArea(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //         padding: EdgeInsets.zero,
          //         onPressed: () {

          //         },
          //         icon: Icon(Icons.logout)),
          //     SizedBox(
          //       width: 20.w,
          //     )
          //   ],
          // ),
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
            "${locator<AuthService>().providerProfile!.businessName}",
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

              Get.to(
                () => EditDetailsScreen(),
              );
            },
            child: Container(
              height: 60.h,
              width: 350.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Colors.blue,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade400,
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

                        Get.to(
                          () => EditDetailsScreen(),
                        );
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
                      "Edit Details",
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

              Get.to(() => ConversationScreen());
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

                        Get.to(() => ConversationScreen());
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

              Get.to(() => WebviewScreen());
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

                        Get.to(() => WebviewScreen());
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
                      "My Website",
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
      padding: const EdgeInsets.only(top: 33, bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "RATING",
            style: headingTextStyle.copyWith(
                fontSize: 13, fontFamily: robottoFontTextStyle),
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
                        crossAxisCount: 2,
                        mainAxisExtent: 280.h,
                        crossAxisSpacing: 10),
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
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 10),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 250.h,
                                      width: 1.sw / 2.4,
                                      child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              '$assets/placeholder.jpeg',
                                          image: model.services[index].imgUrl!),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          bottom: 250.h - 40.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 24.h,
                                            width: 24.w,
                                            decoration: BoxDecoration(
                                                color: model.services[index]
                                                            .availability ==
                                                        "Available"
                                                    ? Color(0XFF0ACF83)
                                                    : model.services[index]
                                                                .availability ==
                                                            "Available soon"
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
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: Container(
                                          height: 76.h,
                                          // width:1.
                                          color: Colors.black26,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 6.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                    "Desc: ${model.services[index].description}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: headingTextStyle
                                                                        .copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                              "Price: ${model.services[index].price} usd",
                                                              // "Price: 50 usd",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  headingTextStyle
                                                                      .copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                              "Cat: ${model.services[index].category}",
                                                              // "Price: 50 usd",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  headingTextStyle
                                                                      .copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .white,
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
