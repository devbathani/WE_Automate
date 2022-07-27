import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class ProviderSearchScreen extends StatefulWidget {
  const ProviderSearchScreen({Key? key}) : super(key: key);

  @override
  _ProviderSearchScreenState createState() => _ProviderSearchScreenState();
}

class _ProviderSearchScreenState extends State<ProviderSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ////
      ///FAB
      ///
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
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              _topAppBar(),
              // SizedBox(
              //   height: 40.h,
              // ),
              searchTextField(),
              services(),
              seeMoreButton()
            ],
          ),
        ),
      ),
    );
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

  searchTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 45.h, bottom: 26, left: 16, right: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          height: 52.h,
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 2.w)),
          child: TextFormField(
            decoration: InputDecoration(
                hintStyle: bodyTextStyle.copyWith(
                    fontSize: 15.sp,
                    fontFamily: robottoFontTextStyle,
                    color: Colors.grey.withOpacity(1)),
                hintText: "Search all services",
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
        Row(
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
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 17.0),
          child: Text(
            "Search Services  and Products",
            style: subHeadingTextstyle.copyWith(
                fontSize: 13.sp,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w300),
          ),
        )
      ],
    );
  }
}
