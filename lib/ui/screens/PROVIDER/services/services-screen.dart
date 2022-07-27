import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/add_services/add-service-screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/services-view-model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.loading,
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topAppBar(),
                    buttonsArea(model),
                    galleryView(model),
                    model.services.length < 6 && model.state == ViewState.idle
                        ? SizedBox(height: 100.h)
                        : seeMoreButton()
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

  _topAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                "Back",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  buttonsArea(ServicesViewModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 26, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () async {
              final serviceToBeAdded =
                  await Get.to(() => AddServiceScreen()) ?? null;
              if (serviceToBeAdded != null) {
                await model.addToMyServices(serviceToBeAdded);
              } else {
                print("Service is not added ===> null");
              }
            },
            child: Container(
              height: 72.h,
              width: 380.w,
              decoration: BoxDecoration(
                color: Color(0XFF1b77f2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "$assets/new.png",
                      height: 40.h,
                      width: 40.w,
                    ),
                    Text(
                      "Create New Service",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "My Listed Services",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Color(0XFF1b77f2),
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  galleryView(ServicesViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(
          model.services.length,
          (index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 5.h,
              ),
              child: Stack(
                children: [
                  Container(
                    height: 300.h,
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.services[index].title!,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Color(0XFF1b77f2),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Stack(
                          fit: StackFit.loose,
                          children: [
                            Container(
                              height: 245.h,
                              width: 340.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Image.asset(
                                model.services[index].imgUrl!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                height: 90.h,
                                width: 340.w,
                                color: Colors.black26,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 9.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Desc: ",
                                                softWrap: true,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                    color: Color(0XFF1b77f2),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                " ${model.services[index].description}",
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Text(
                                            "Price: ",
                                            // "Price: 50 CAD",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Color(0XFF1b77f2),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${model.services[index].price} CAD",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "CAT: ",
                                            // "Price: 50 CAD",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Color(0XFF1b77f2),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${model.services[index].category} ",
                                            // "Price: 50 CAD",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 50.h,
                  //   right: 5.w,
                  //   child: InkWell(
                  //     onTap: () async {
                  //       Get.to(() => EditServiceScreen(
                  //             service: model.services[index],
                  //           ));
                  //     },
                  //     child: Container(
                  //       height: 60.h,
                  //       width: 60.w,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: Center(
                  //         child: Icon(
                  //           Icons.edit,
                  //           color: Color(0XFF1b77f2),
                  //           size: 30.sp,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
