import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/conversation/chat/customer-chat-screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class CustomerSearchServicesScreen extends StatefulWidget {
  final isBottom;
  const CustomerSearchServicesScreen({this.isBottom = false});

  @override
  _CustomerSearchServicesScreenState createState() =>
      _CustomerSearchServicesScreenState();
}

class _CustomerSearchServicesScreenState
    extends State<CustomerSearchServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerBookingScreenViewModel(),
      child: Consumer<CustomerBookingScreenViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.loading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 40.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topAppBar(),
                    searchTextField(model),
                    services(model),
                    model.services.length >= 5 && model.state == ViewState.idle
                        ? seeMoreButton()
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  services(CustomerBookingScreenViewModel model) {
    return model.filteredServices.length >= 1 && model.state == ViewState.idle
        ? Padding(
            padding: const EdgeInsets.only(left: 22, right: 22.0),
            child: Column(
              children: [
                SizedBox(
                  height: 26.h,
                ),
                GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 280.h,
                  ),
                  shrinkWrap: true,
                  itemCount: model.filteredServices.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Text("title"),
                            Text("${model.filteredServices[index].title}"),
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
                                    () => CustomerBookingScreen(
                                      model: model.services[index],
                                      providerId:
                                          model.services[index].providerId ??
                                              "",
                                      serviceId: model.services[index].id ?? "",
                                      price: model.services[index].price ?? "",
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      // height: 250.h,
                                      // width: 250.w,
                                      height: 230.h,
                                      width: 350.w,
                                      child: Image.asset(
                                        model.filteredServices[index].imgUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        bottom: 250.h - 50.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 24.h,
                                            width: 24.w,
                                            decoration: BoxDecoration(
                                              color: model
                                                          .filteredServices[
                                                              index]
                                                          .availability ==
                                                      "Available"
                                                  ? Color(0XFF0ACF83)
                                                  : model
                                                              .filteredServices[
                                                                  index]
                                                              .availability ==
                                                          "Available soon"
                                                      ? Color(0XFFFBF90A)
                                                      : Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print("Launchig maps");
                                              try {
                                                MapsLauncher.launchCoordinates(
                                                  double.parse(model
                                                      .filteredServices[index]
                                                      .location!
                                                      .lat!),
                                                  double.parse(model
                                                      .filteredServices[index]
                                                      .location!
                                                      .long!),
                                                );
                                              } catch (e) {
                                                print(
                                                    "Exception ====> MAP LAUNCHER==> $e");
                                                Get.dialog(RequestFailedDialog(
                                                    errorMessage:
                                                        e.toString()));
                                              }
                                            },
                                            child: Container(
                                              height: 36.h,
                                              width: 36.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white),
                                              child: Icon(Icons.location_on,
                                                  size: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: Container(
                                          // height: 100.h,
                                          height: 90.h,
                                          width: 350.w,
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
                                                              Text(
                                                                  "Desc: ${model.filteredServices[index].description}",
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
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                              "Price: ${model.filteredServices[index].price} CAD",
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
                                                          SizedBox(
                                                              height: 10.h),
                                                          // TODO: here is after search

                                                          Container(
                                                            height: 30.h,
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.to(() =>
                                                                          CustomerChatScreen(
                                                                            providerId:
                                                                                model.filteredServices[index].providerId,
                                                                            providerName:
                                                                                model.filteredServices[index].providerName,
                                                                          ));
                                                                    },
                                                                    child: Text(
                                                                        "Message")),
                                                          ),
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
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => CustomerBookingScreen(
                                    model: model.services[index],
                                    providerId:
                                        model.services[index].providerId ?? "",
                                    serviceId: model.services[index].id ?? "",
                                    price: model.services[index].price ?? "",
                                  ),
                                );
                              },
                              child: ImageContainer(
                                assets: "$assets/heart.png",
                                height: 28.h,
                                width: 27.w,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: Get.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
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
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => CustomerBookingScreen(
                                        model: model.services[index],
                                        providerId:
                                            model.services[index].providerId ??
                                                "",
                                         serviceId:
                                            model.services[index].id ?? "",
                                        price:
                                            model.services[index].price ?? "",
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 300.h,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Image.asset(
                                      model.services[index].imgUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: Get.width,
                                    color: Colors.black26,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                        vertical: 9.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  " ${model.services[index].description}",
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                          SizedBox(height: 20.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: 35.h,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                        (states) =>
                                                            Color(0xff8B53FF),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.to(
                                                        () =>
                                                            CustomerBookingScreen(
                                                          model: model
                                                              .services[index],
                                                          providerId: model
                                                                  .services[
                                                                      index]
                                                                  .providerId ??
                                                              "",
                                                          serviceId: model
                                                                  .services[
                                                                      index]
                                                                  .id ??
                                                              "",
                                                          price: model
                                                                  .services[
                                                                      index]
                                                                  .price ??
                                                              "",
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      "Book service",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Container(
                                                  height: 35.h,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                        (states) =>
                                                            Color(0xff8B53FF),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.to(
                                                        () => CustomerChatScreen(
                                                            providerId: model
                                                                .services[index]
                                                                .providerId,
                                                            providerName: model
                                                                .services[index]
                                                                .providerName),
                                                      );
                                                    },
                                                    child: Text(
                                                      "Message",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
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
          onPressed: () {},
        ),
      ),
    );
  }

  searchTextField(CustomerBookingScreenViewModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 26, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60.h,
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  model.searchServices(value);
                } else {
                  model.filteredServices = [];
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 25.w,
                  vertical: 10.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xff8B53FF),
                    width: 7,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.r),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xff8B53FF),
                    width: 7,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.r),
                  ),
                ),
                hintText: "Search all Services",
                hintStyle: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
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
                "Available Services",
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
          Divider(
            color: Colors.black,
            thickness: 5,
          ),
        ],
      ),
    );
  }
}
