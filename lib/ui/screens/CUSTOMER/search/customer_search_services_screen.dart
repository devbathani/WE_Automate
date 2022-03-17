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
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../customer_booking/slotinfo.dart';

class CustomerSearchServicesScreen extends StatefulWidget {
  final isBottom;
  const CustomerSearchServicesScreen({this.isBottom = false});

  @override
  _CustomerSearchServicesScreenState createState() => _CustomerSearchServicesScreenState();
}

class _CustomerSearchServicesScreenState extends State<CustomerSearchServicesScreen> {
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
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    _topAppBar(),
                    // searchTextField(model),
                    
                    services(model),
                    model.services.length >= 5 && model.state == ViewState.idle ? seeMoreButton() : Container()
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
                              padding: const EdgeInsets.only(top: 8.0, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => CustomerBookingScreen(
                                      model: model.services[index],
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 250.h,
                                      width: 250.w,
                                      child: FadeInImage.assetNetwork(
                                        fit: BoxFit.cover,
                                        placeholder: '$assets/placeholder.jpeg',
                                        image: model.filteredServices[index].imgUrl!,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        bottom: 250.h - 50.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 24.h,
                                            width: 24.w,
                                            decoration: BoxDecoration(
                                              color: model.filteredServices[index].availability == "Available"
                                                  ? Color(0XFF0ACF83)
                                                  : model.filteredServices[index].availability == "Available soon"
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
                                                  double.parse(model.filteredServices[index].location!.lat!),
                                                  double.parse(model.filteredServices[index].location!.long!),
                                                );
                                              } catch (e) {
                                                print("Exception ====> MAP LAUNCHER==> $e");
                                                Get.dialog(RequestFailedDialog(errorMessage: e.toString()));
                                              }
                                            },
                                            child: Container(
                                              height: 36.h,
                                              width: 36.w,
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                              child: Icon(Icons.location_on, size: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 0),
                                        child: Container(
                                          height: 100.h,
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
                                                                child: Text(
                                                                    "Desc: ${model.filteredServices[index].description}",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: headingTextStyle.copyWith(
                                                                      fontSize: 12.sp,
                                                                      color: Colors.white,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text("Price: ${model.filteredServices[index].price} CAD",
                                                              // "Price: 50 CAD",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: headingTextStyle.copyWith(
                                                                fontSize: 12.sp,
                                                                color: Colors.white,
                                                              )),
                                                          SizedBox(height: 10.h),
                                                          Container(
                                                            height: 30.h,
                                                            child: ElevatedButton(
                                                                onPressed: () {
                                                                  Get.to(() => CustomerChatScreen(
                                                                        providerId:
                                                                            model.filteredServices[index].providerId,
                                                                        providerName:
                                                                            model.filteredServices[index].providerName,
                                                                      ));
                                                                },
                                                                child: Text("Message")),
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
        : Container(
            height: 580.h,
            width: double.infinity,
            child: ListView.builder(
              itemCount: model.services.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: Container(
                    height: 265.h,
                    width: 350.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.services[index].title!,
                          style: subBodyTextStyle.copyWith(fontSize: 17.5.sp),
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
                                  ),
                                );
                              },
                              child: Container(
                                height: 230.h,
                                width: 350.w,
                                child: FadeInImage.assetNetwork(
                                  placeholder: '$assets/placeholder.jpeg',
                                  image: model.services[index].imgUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 10.w,
                              child: Container(
                                height: 24.h,
                                width: 24.w,
                                decoration: BoxDecoration(
                                  color: model.services[index].availability == "Available"
                                      ? Color(0XFF0ACF83)
                                      : model.services[index].availability == "Available soon"
                                          ? Color(0XFFFBF90A)
                                          : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              right: 10.w,
                              child: GestureDetector(
                                onTap: () {
                                  print("Launchig maps");
                                  try {
                                    MapsLauncher.launchCoordinates(
                                      double.parse(model.services[index].location!.lat!),
                                      double.parse(model.services[index].location!.long!),
                                    );
                                  } catch (e) {
                                    print("Exception ====> MAP LAUNCHER==> $e");
                                    Get.dialog(
                                      RequestFailedDialog(
                                        errorMessage: e.toString(),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 36.h,
                                  width: 36.w,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  child: Icon(Icons.location_on, size: 18),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 90.h,
                                width: 350.w,
                                color: Colors.black26,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 9.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Flexible(
                                          child: Text(
                                            "Desc: ${model.services[index].description}",
                                            softWrap: true,
                                            style: headingTextStyle.copyWith(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Price: ${model.services[index].price} CAD",
                                        // "Price: 50 CAD",
                                        overflow: TextOverflow.ellipsis,
                                        style: headingTextStyle.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 30.h,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(
                                                  () => CustomerChatScreen(
                                                    providerId: model.services[index].providerId,
                                                    providerName: model.services[index].providerName,
                                                  ),
                                                );
                                              },
                                              child: Text("Message"),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 10),
                                            height: 30.h,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith((states) => Colors.green)),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return SlotInfo();
                                                }));
                                              },
                                              child: Text("Book service"),
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
          onPressed: () {},
        ),
      ),
    );
  }

  searchTextField(CustomerBookingScreenViewModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 45.h, bottom: 26, left: 16, right: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          height: 52.h,
          decoration: BoxDecoration(border: Border.all(color: primaryColor, width: 2.w)),
          child: TextField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                model.searchServices(value);
              } else {
                model.filteredServices = [];

                setState(() {});
              }
              // setState(() {});
            },
            decoration: InputDecoration(
                hintStyle: bodyTextStyle.copyWith(
                    fontSize: 15.sp, fontFamily: robottoFontTextStyle, color: Colors.grey.withOpacity(1)),
                hintText: "Search all services",
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 29.h,
                  maxWidth: 36.w,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 11.w),
                  child: ImageContainer(assets: "$assets/pin.png", height: 29.h, width: 36.w, fit: BoxFit.contain),
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
            if (widget.isBottom) {
              Get.offAll(() => RootSCustomercreen());
            }
            {
              Get.back();
            }
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
                      fontSize: 13.sp, letterSpacing: 0.4, fontFamily: robottoFontTextStyle),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 17.0),
          child: Text(
            "Search Services  and Products",
            style: subHeadingTextstyle.copyWith(fontSize: 13.sp, letterSpacing: 0.4, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
