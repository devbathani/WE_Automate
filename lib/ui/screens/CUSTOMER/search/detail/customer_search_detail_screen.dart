import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/webview/webview-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'customer_search_detail_view_model.dart';

class CustomerSearchDetailScreen extends StatefulWidget {
  @override
  _CustomerSearchDetailScreenState createState() =>
      _CustomerSearchDetailScreenState();
}

class _CustomerSearchDetailScreenState
    extends State<CustomerSearchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerSearchDetailViewModel(),
      child: Consumer<CustomerSearchDetailViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.loading,
          child: Scaffold(
            ////
            ///FAB
            ///
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
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    _topAppBar(),
                    // SizedBox(
                    //   height: 40.h,
                    // ),
                    searchTextField(model),
                    Row(
                      children: [
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          "All Results",
                          style: headingTextStyle.copyWith(
                            fontSize: 13.sp,
                            fontFamily: robottoFontTextStyle,
                          ),
                        )
                      ],
                    ),
                    searchList(model),
                    model.products.length < 3 ? Container() : seeMoreButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchList(CustomerSearchDetailViewModel model) {
    return model.filteredProducts.length >= 1 && model.state == ViewState.idle
        ? Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 220.h),
                itemCount: model.filteredProducts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 28.0, right: 12),
                      child: Material(
                        elevation: 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: 167.w,
                              height: 220.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          model.filteredProducts[index].imgUrl!)

                                      // AssetImage(index.isEven
                                      //     ? "$assets/product2.png"
                                      //     : "$assets/product0.png")
                                      )),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 90.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => WebviewCustomerScreen());
                                      },
                                      child: Container(
                                        height: 34.h,
                                        width: 56.w,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: ImageContainer(
                                          assets: "$assets/cart.png",
                                          height: 34.h,
                                          width: 56.w,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${model.filteredProducts[index].title}",
                                style: headingTextStyle.copyWith(
                                    fontSize: 13.sp,
                                    fontFamily: robottoFontTextStyle),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
          )
        : Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 220.h),
                itemCount: model.products.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 28.0, right: 12),
                      child: Material(
                        elevation: 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => WebviewCustomerScreen());
                              },
                              child: Container(
                                width: 167.w,
                                height: 220.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      model.products[index].imgUrl!,
                                    ),

                                    // AssetImage(index.isEven
                                    //     ? "$assets/product2.png"
                                    //     : "$assets/product0.png")
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 90.0, left: 9.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 24.h,
                                        width: 24.w,
                                        decoration: BoxDecoration(
                                            color: model.products[index]
                                                        .availability ==
                                                    "Available"
                                                ? Color(0XFF0ACF83)
                                                : model.products[index]
                                                            .availability ==
                                                        "Available soon"
                                                    ? Color(0XFFFBF90A)
                                                    : Colors.red,
                                            shape: BoxShape.circle),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => WebviewCustomerScreen());
                                        },
                                        child: Container(
                                          height: 34.h,
                                          width: 56.w,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: ImageContainer(
                                            assets: "$assets/cart.png",
                                            height: 34.h,
                                            width: 56.w,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${model.products[index].title}",
                                style: headingTextStyle.copyWith(
                                    fontSize: 13.sp,
                                    fontFamily: robottoFontTextStyle),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
          );
    // StaggeredGridView.countBuilder(
    //   crossAxisCount: 4,
    //   itemCount: 4,
    //   shrinkWrap: true,
    //   physics: BouncingScrollPhysics(),
    //   itemBuilder: (BuildContext context, int index) => Stack(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.all(3),
    //         padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
    //         // height: 120.0.h,
    //         // width: 120.0.w,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(0),
    //           image: DecorationImage(
    //             image: AssetImage(index % 2 == 0
    //                 ? "$assets/product0.png"
    //                 : "$assets/product2.png"),
    //             fit: BoxFit.contain,
    //           ),
    //           shape: BoxShape.rectangle,
    //         ),
    //       ),
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 10.0),
    //           child: Text("\$ 35",
    //               style: headingTextStyle.copyWith(
    //                 fontSize: 13.sp,
    //               )),
    //         ),
    //       ),
    //     ],
    //   ),
    //   staggeredTileBuilder: (int index) =>
    //       StaggeredTile.count(2, index.isEven ? 2.5 : 2.5),
    //   mainAxisSpacing: 30.0,
    //   crossAxisSpacing: 4.0,
    // );
  }

  services() {
    return Padding(
        padding: const EdgeInsets.only(left: 22, right: 22.0),
        child: Column(
          children: [
            //barber
            Column(
              children: [
                Row(
                  children: [
                    Text("Barber"),
                  ],
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 10),
                      child: Container(
                        height: 250.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("$assets/d6.png")),
                        ),
                      ),
                    ),
                    ImageContainer(
                        assets: "$assets/heart.png", height: 28.h, width: 27.w),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 26.h,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Hair Services"),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 10),
                          child: Container(
                            height: 250.h,
                            width: 1.sw / 2.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("$assets/d5.png")),
                            ),
                          ),
                        ),
                        ImageContainer(
                            assets: "$assets/heart.png",
                            height: 28.h,
                            width: 27.w),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Spa"),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 10),
                          child: Container(
                            height: 250.h,
                            width: 1.sw / 2.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("$assets/d4.png")),
                            ),
                          ),
                        ),
                        ImageContainer(
                            assets: "$assets/heart.png",
                            height: 28.h,
                            width: 27.w),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        )
        // StaggeredGridView.countBuilder(
        //   crossAxisCount: 4,
        //   itemCount: 4,
        //   shrinkWrap: true,
        //   physics: BouncingScrollPhysics(),
        //   itemBuilder: (BuildContext context, int index) => Stack(
        //     children: [
        //       Container(
        //         margin: const EdgeInsets.all(3),
        //         padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
        //         // height: 120.0.h,
        //         // width: 120.0.w,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(0),
        //           image: DecorationImage(
        //             image: AssetImage("$assets/product0.png"),
        //             fit: BoxFit.contain,
        //           ),
        //           shape: BoxShape.rectangle,
        //         ),
        //       ),
        //       Align(
        //         alignment: Alignment.bottomCenter,
        //         child: Padding(
        //           padding: const EdgeInsets.only(top: 18.0),
        //           child: Text("\$ 35",
        //               style: headingTextStyle.copyWith(
        //                 fontSize: 13.sp,
        //               )),
        //         ),
        //       ),
        //     ],
        //   ),
        //   staggeredTileBuilder: (int index) => StaggeredTile.extent(
        //       1, (1 / 3) * MediaQuery.of(context).size.width),
        //   mainAxisSpacing: 30.0,
        //   crossAxisSpacing: 4.0,
        // ),
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

  searchTextField(CustomerSearchDetailViewModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 45.h, bottom: 26, left: 16, right: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          height: 52.h,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 2.w)),
          child: TextField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                model.searchProducts(value);
              } else {
                model.filteredProducts = [];

                setState(() {});
              }
              // setState(() {});
            },
            decoration: InputDecoration(
                hintStyle: bodyTextStyle.copyWith(
                    fontSize: 15.sp,
                    fontFamily: robottoFontTextStyle,
                    color: Colors.grey.withOpacity(1)),
                hintText: "Search all products",
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 29.h,
                  maxWidth: 36.w,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 11.w),
                  child: ImageContainer(
                      assets: "$assets/pin.png",
                      height: 29.h,
                      width: 36.w,
                      fit: BoxFit.contain),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 18, top: 2.h)),
          ),
        ),
      ]),
    );
  }

  _topAppBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // Get.back();
            Get.offAll(() => RootSCustomercreen());
          },
          child: Container(
            child: Row(
              children: [
                SizedBox(width: 20.w),
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
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 17.0),
          child: Text(
            "Search Services  and Products",
            style: subHeadingTextstyle.copyWith(
                fontSize: 13.sp,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
