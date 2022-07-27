import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/edit_details/edit_business_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/profile/provider-profile-view-model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/webview/webview-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/strings.dart';
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
                  avatarArea(context),
                  buttonsArea(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  avatarArea(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100.h,
          ),
          Text(
            "Hey there..",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black87,
                fontSize: 25.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Text(
            "${locator<AuthService>().providerProfile!.businessName}",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Color.fromARGB(221, 55, 82, 238),
                fontSize: 30.sp,
                fontWeight: FontWeight.w300,
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
              height: 70.h,
              width: 380.w,
              decoration: BoxDecoration(
                color: Color(0XFF1b77f2),
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
                      "$static_assets/ed.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      "Edit Details",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w300,
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
              Get.to(
                () => ConversationScreen(),
              );
            },
            child: Container(
              height: 70.h,
              width: 380.w,
              decoration: BoxDecoration(
                color: Color(0XFF1b77f2),
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
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w300,
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
              Provider.of<ProviderAuthViewModel>(context, listen: false)
                  .logout();
              Get.offAll(() => SelectUserTypeScreen());
            },
            child: Container(
              height: 70.h,
              width: 380.w,
              decoration: BoxDecoration(
                color: Color(0XFF1b77f2),
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
                      "$static_assets/logout.png",
                      height: 50.h,
                      width: 50.w,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      "Logout",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Made with  💜 by",
                style: TextStyle(
                  color: Color(0XFF1b77f2),
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          InkWell(
            onTap: () {
              print(":");

              Get.to(() => WebviewScreen());
            },
            child: Container(
              height: 70.h,
              width: 380.w,
              decoration: BoxDecoration(
                color: Color(0XFF1b77f2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "We Automate",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w300,
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
}
