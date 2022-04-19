import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topAppBar(),
                    buttonsArea(model),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        galleryView(model),
                        model.services.length < 6 &&
                                model.state == ViewState.idle
                            ? SizedBox(height: 100.h)
                            : seeMoreButton(),
                      ],
                    )
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
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
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
                color: Color(0xff8B53FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  "Create New Service",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Color(0xff8B53FF),
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
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
        ...List.generate(
          model.services.length,
          (index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              child: Container(
                height: 300.h,
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.services[index].title!,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Color(0xff8B53FF),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 250.h,
                          width: 340.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: FadeInImage.assetNetwork(
                            placeholder: '$assets/placeholder.jpeg',
                            image: model.services[index].imgUrl!,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            height: 90.h,
                            width: w,
                            color: Colors.black26,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 9.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Desc: ",
                                            softWrap: true,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Color(0xff8B53FF),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${model.services[index].description}",
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w800,
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
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: Color(0xff8B53FF),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " ${model.services[index].price} CAD",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
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
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: Color(0xff8B53FF),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " ${model.services[index].category} ",
                                        // "Price: 50 CAD",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
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
            );
          },
        )
      ],
    );
  }
}
