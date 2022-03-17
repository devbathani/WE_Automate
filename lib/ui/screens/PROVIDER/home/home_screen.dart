import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/auth_signup/provider_auth_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/booking/booking-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/home/home_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/products/product-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/root/root-provider-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/service-details-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/services-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/webview/webview-screen.dart';
import 'package:antonx_flutter_template/ui/screens/common_ui/select_user_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';
import '../booking/slotSchedular.dart';

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
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.offAll(() => RootProviderScreen(index: 3));
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

                  buttonsArea(model),
                  SizedBox(height: 24.h),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      height: 26.h,
                      width: 184.w,
                      child: RoundedRaisedButton(
                          buttonText: "Schedule Slots",
                          textColor: primaryColor,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return SlotSchedular();
                            }));
                          }),
                    ),
                  ]),

                  ratings(),
                  

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
          height: 40.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Provider.of<ProviderAuthViewModel>(context, listen: false).logout();
                  Get.offAll(() => SelectUserTypeScreen());
                },
                icon: Icon(Icons.logout)),
            SizedBox(
              width: 20.w,
            )
          ],
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
      ],
    );
  }

  buttonsArea(HomeViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 20.h,
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
        SizedBox(height: 17.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "PRODUCTS",
                  onPressed: () {
                    print(":");
                    Get.to(() => ProductScreen());
                  }),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "SERVICES",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () async {
                    print(":");

                    final result = await Get.to(() => ServicesScreen()) ?? null;
                    if (result == null) {
                      model.getAllServices();
                      model.setState(ViewState.idle);
                    } else {
                      model.getAllServices();
                      model.setState(ViewState.idle);
                    }
                  }),
            ),
          ],
        ),
        SizedBox(height: 21.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "MESSAGE",
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
                  buttonText: "BOOKING",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");

                    Get.to(() => BookingScreen());
                  }),
            ),
          ],
        )
      ],
    );
  }

  ratings() {
    return Padding(
      padding: const EdgeInsets.only(top: 33, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "RATING",
            style: headingTextStyle.copyWith(fontSize: 13, fontFamily: robottoFontTextStyle),
          ),
          SizedBox(width: 5.0.w),
          RatingBarIndicator(
            rating: 0, //2.75,
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
                                          placeholder: '$assets/placeholder.jpeg',
                                          image: model.services[index].imgUrl!,
                                        ),
                                      ),
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
                                                          Text("Price: ${model.services[index].price} CAD",
                                                              // "Price: 50 CAD",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: headingTextStyle.copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors.white,
                                                              )),
                                                          SizedBox(height: 4.h),
                                                          Text("Cat: ${model.services[index].category}",
                                                              // "Price: 50 CAD",
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
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Text("No service available"),
                ),
        ),
        SizedBox(height: 100)
      ],
    );
    // Column(
    // children: [
    // Expanded(
    // child:
    //   Padding(
    // padding: const EdgeInsets.symmetric(horizontal: 21.0),
    // child: model.services.length < 1 && model.state == ViewState.idle
    //     ? Center(
    //         child: Text("No service available"),
    //       )
    // :
    // StaggeredGridView.countBuilder(
    //     crossAxisCount: 4,
    //     itemCount: model.services.length,
    //     shrinkWrap: true,
    //     physics: BouncingScrollPhysics(),
    //     itemBuilder: (BuildContext context, int index) =>
    //         // CustomStaggeredTile(
    //         //     imagePath: stylistImages[index].path,
    //         //     text: stylistImages[index].title),
    //         Container(
    //             margin: const EdgeInsets.all(3),
    //             padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
    //             // height: 120.0.h,
    //             // width: 120.0.w,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(0),
    //               // image: DecorationImage(
    //               //   image: AssetImage("$assets/gallery0.png"),
    //               //   fit: BoxFit.cover,
    //               // ),
    //               shape: BoxShape.rectangle,
    //             ),
    //             child: FadeInImage.assetNetwork(
    //                 fit: BoxFit.cover,
    //                 placeholder: '$assets/placeholder.jpeg',
    //                 image: model.services[index].imgUrl!)),
    //     staggeredTileBuilder: (int index) =>
    //         StaggeredTile.count(2, index.isEven ? 3 : 2),
    //     mainAxisSpacing: 4.0,
    //     crossAxisSpacing: 4.0,
    //   ),
    // );
    // ,
    //       ),
    //   ],
    // ),;
  }
}
