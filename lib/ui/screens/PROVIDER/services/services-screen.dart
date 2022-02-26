import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/webview/webview-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/add_services/add-service-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/edit_services/edit-services-screen.dart';

import 'package:maps_launcher/maps_launcher.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/services-view-model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/webview/webview-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.loading,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
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
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 28.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          ImageContainer(
                            assets: "$assets/back.png",
                            height: 10,
                            width: 10,
                          ),
                          SizedBox(width: 13.29),
                          Text(
                            "BACK",
                            style: subHeadingTextstyle.copyWith(
                                fontSize: 13.sp,
                                letterSpacing: 0.4,
                                fontFamily: robottoFontTextStyle),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///avatar user one area
                  ///
                  avatarArea(),

                  buttonsArea(model),

                  ratings(),

                  galleryView(model),

                  model.services.length < 6 && model.state == ViewState.idle
                      ? SizedBox(height: 100.h)
                      : seeMoreButton(),
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

  avatarArea() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
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
                  style: headingTextStyle.copyWith(
                      height: 1.6,
                      fontSize: 13.sp,
                      fontFamily: robottoFontTextStyle),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "${locator<AuthService>().providerProfile!.businessName!}"
              .toUpperCase(),
          style: headingTextStyle.copyWith(
              fontSize: 13.sp, fontFamily: robottoFontTextStyle),
        )
      ],
    );
  }

  buttonsArea(ServicesViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //   Container(
        //     height: 24.h,
        //     width: 170.w,
        //     child: RoundedRaisedButton(
        //         buttonText: "WEBSITE",
        //         textColor: primaryColor,
        //         color: Colors.white,
        //         onPressed: () {
        //           print(":");
        //           Get.to(() => WebviewScreen());
        //         }),
        //   ),
        // ]),
        SizedBox(height: 19.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "CREATE NEW SERVICE",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () async {
                    print(":");
                    final serviceToBeAdded =
                        await Get.to(() => AddServiceScreen()) ?? null;
                    if (serviceToBeAdded != null) {
                      await model.addToMyServices(serviceToBeAdded);
                    } else {
                      print("Service is not added ===> null");
                    }
                  }),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "WEBSITE",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");
                    // Get.back();
                    Get.to(() => WebviewScreen());
                  }),
            ),
          ],
        )
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

  addServiceTile(model) {
    return GestureDetector(
      onTap: () async {
        final serviceToBeAdded = await Get.to(() => AddServiceScreen()) ?? null;
        if (serviceToBeAdded != null) {
          await model.addToMyServices(serviceToBeAdded);
        } else {
          print("Service is not added ===> null");
        }
      },
      child: Container(
          margin: const EdgeInsets.all(3),
          padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              shape: BoxShape.rectangle,
              color: Colors.grey.withOpacity(0.4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 80.0,
                color: Colors.grey.withOpacity(0.8),
              )
            ],
          )),
    );
  }

  galleryView(ServicesViewModel model) {
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
                    itemCount: (model.services.length + 1),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? addServiceTile(model)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Text("title"),
                                    Text("${model.services[index - 1].title}"),
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 10),
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
                                                image: model.services[index - 1]
                                                    .imgUrl!),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 12,
                                                right: 12,
                                                bottom: 250.h - 50.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 24.h,
                                                  width: 24.w,
                                                  decoration: BoxDecoration(
                                                      color: model
                                                                  .services[
                                                                      index - 1]
                                                                  .availability ==
                                                              "Available"
                                                          ? Color(0XFF0ACF83)
                                                          : model
                                                                      .services[
                                                                          index -
                                                                              1]
                                                                      .availability ==
                                                                  "Available soon"
                                                              ? Color(
                                                                  0XFFFBF90A)
                                                              : Colors.red,
                                                      shape: BoxShape.circle),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final edittedService =
                                                        await Get.to(() =>
                                                                EditServiceScreen(
                                                                  service: model
                                                                          .services[
                                                                      index -
                                                                          1],
                                                                )) ??
                                                            null;
                                                    if (edittedService !=
                                                        null) {
                                                      await model.updateService(
                                                          edittedService,
                                                          index - 1);
                                                    } else {
                                                      print("service is null");
                                                    }
                                                    // model.setState(
                                                    //     ViewState.idle);
                                                  },
                                                  child: Container(
                                                    height: 36.h,
                                                    width: 36.w,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    child: Icon(Icons.edit,
                                                        size: 18),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0),
                                              child: Container(
                                                height: 76.h,
                                                // width:1.
                                                color: Colors.black26,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                          "Desc: ${model.services[index - 1].description}",
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style:
                                                                              headingTextStyle.copyWith(
                                                                            fontSize:
                                                                                12.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        4.h),
                                                                Text(
                                                                    "Price: ${model.services[index - 1].price} CAD",
                                                                    // "Price: 50 usd",
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
                                                                SizedBox(
                                                                    height:
                                                                        4.h),
                                                                Text(
                                                                    "Cat: ${model.services[index - 1].category}",
                                                                    // "Price: 50 usd",
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
                : Container())
      ],
    );
    //  model.services.length < 1 && model.state == ViewState.idle
    //     ? Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 21.0),
    //         child: StaggeredGridView.countBuilder(
    //           crossAxisCount: 4,
    //           itemCount: 1,
    //           shrinkWrap: true,
    //           physics: BouncingScrollPhysics(),
    //           itemBuilder: (BuildContext context, int index) => GestureDetector(
    //             onTap: () async {
    //               final serviceToBeAdded =
    //                   await Get.to(() => AddServiceScreen()) ?? null;
    //               if (serviceToBeAdded != null) {
    //                 await model.addToMyServices(serviceToBeAdded);
    //               } else {
    //                 print("Service is not added ===> null");
    //               }
    //             },
    //             child: Container(
    //                 margin: const EdgeInsets.all(3),
    //                 padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(0),
    //                     shape: BoxShape.rectangle,
    //                     color: Colors.grey.withOpacity(0.4)),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Icon(
    //                       Icons.add,
    //                       size: 80.0,
    //                       color: Colors.grey.withOpacity(0.8),
    //                     )
    //                   ],
    //                 )),
    //           ),
    //           staggeredTileBuilder: (int index) =>
    //               StaggeredTile.count(2, index.isEven ? 3 : 2),
    //           mainAxisSpacing: 30.0,
    //           crossAxisSpacing: 4.0,
    //         ),
    //       )
    //     : // Column(
    //     // children: [
    //     // Expanded(
    //     // child:
    //     Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 21.0),
    //         child: StaggeredGridView.countBuilder(
    //           crossAxisCount: 4,
    //           itemCount: model.services.length + 1,
    //           shrinkWrap: true,
    //           physics: BouncingScrollPhysics(),
    //           itemBuilder: (BuildContext context, int index) => index == 0
    //               ? GestureDetector(
    //                   onTap: () async {
    //                     final serviceToBeAdded =
    //                         await Get.to(() => AddServiceScreen()) ?? null;
    //                     if (serviceToBeAdded != null) {
    //                       await model.addToMyServices(serviceToBeAdded);
    //                     } else {
    //                       print("Service is not added ===> null");
    //                     }
    //                   },
    //                   child: Container(
    //                       margin: const EdgeInsets.all(3),
    //                       padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
    //                       decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(0),
    //                           shape: BoxShape.rectangle,
    //                           color: Colors.grey.withOpacity(0.4)),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Icon(
    //                             Icons.add,
    //                             size: 80.0,
    //                             color: Colors.grey.withOpacity(0.8),
    //                           )
    //                         ],
    //                       )),
    //                 )
    //               // CustomStaggeredTile(
    //               //     imagePath: stylistImages[index].path,
    //               //     text: stylistImages[index].title),
    //               : Container(
    //                   margin: const EdgeInsets.all(3),
    //                   padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
    //                   // height: 120.0.h,
    //                   // width: 120.0.w,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(0),
    //                     // image: DecorationImage(
    //                     //   image: AssetImage("$assets/gallery0.png"),
    //                     //   fit: BoxFit.cover,
    //                     // ),
    //                     shape: BoxShape.rectangle,
    //                   ),
    //                   child: FadeInImage.assetNetwork(
    //                       fit: BoxFit.cover,
    //                       placeholder: '$assets/placeholder.jpeg',
    //                       image: model.services[index - 1].imgUrl!)),
    //           staggeredTileBuilder: (int index) =>
    //               StaggeredTile.count(2, index.isEven ? 3 : 2),
    //           mainAxisSpacing: 30.0,
    //           crossAxisSpacing: 4.0,
    //         ),
    // );
  }
}
