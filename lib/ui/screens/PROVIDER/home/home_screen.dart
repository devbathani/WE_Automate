import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/order_list.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/booking/slotSchedular2.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/home/home_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/service-details-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/services-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../locator.dart';
import '../conversation/conversation-screen.dart';
import '../services/add_services/add-service-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    avatarArea(),
                    buttonsArea(model),
                    SizedBox(height: 24.h),
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

  avatarArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.h,
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

  buttonsArea(HomeViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 60.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SlotSchedular2();
                  },
                ),
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
                      "$static_assets/provider1.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      "My Slots",
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
            onTap: () async {
              print(":");

              final result = await Get.to(() => ServicesScreen()) ?? null;
              if (result == null) {
                model.getAllServices();
                model.setState(ViewState.idle);
              } else {
                model.getAllServices();
                model.setState(ViewState.idle);
              }
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
                      "$static_assets/provider2.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      "My Services",
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
          SizedBox(height: 30.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderList(
                      isProvider: true,
                    );
                  },
                ),
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
                      "$static_assets/provider3.png",
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
              print(":");
              Get.to(() => ConversationScreen());
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
                      "$static_assets/provider4.png",
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
        ],
      ),
    );
  }

  galleryView(HomeViewModel model) {
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
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    ServiceDetailsScreen(
                                      sErvice: model.services[index],
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Hero(
                                      tag: model.services[index].imgUrl!,
                                      child: Container(
                                        height: 250.h,
                                        width: 1.sw / 2.4,
                                        child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              '$assets/placeholder.jpeg',
                                          image: model.services[index].imgUrl!,
                                        ),
                                      ),
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
                                                              "Price: ${model.services[index].price} CAD",
                                                              // "Price: 50 CAD",
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
                                                              // "Price: 50 CAD",
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
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No service available"),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 26.h,
                        width: 172.w,
                        child: RoundedRaisedButton(
                            buttonText: "Add services",
                            color: Colors.white,
                            textColor: primaryColor,
                            onPressed: () {
                              print(":");

                              Get.to(() => AddServiceScreen());
                            }),
                      ),
                    ],
                  ),
                ),
        ),
        SizedBox(height: 100)
      ],
    );
  }
}
