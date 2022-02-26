import 'dart:async';
import 'dart:io';

import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/availability.dart';
// import 'package:antonx_flutter_template/core/models/product.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/locator.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final Completer<GoogleMapController> controller = Completer();
  late CameraPosition initialCameraPosition;
  final _locationService = locator<LocationService>();
  Set<Marker> markers = Set<Marker>();
  final _dbService = locator<DatabaseService>();
  var serviceToBeAdded = SErvice();
  final datetime = DateTime.now();

  List<Marker> pins = [];
  late LatLng markerPosition;
  late String _googleMapsUrl;
  var pinIcon;
  var _formKey = GlobalKey<FormState>();
  CameraPosition _kLocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  File? _image;
  List<Availability> availableOptions = [];

  @override
  void initState() {
    availableOptions
        .add(Availability(color: Color(0xFFF91515), label: "Not available"));
    availableOptions
        .add(Availability(color: Color(0XFFFBF90A), label: "Available soon"));
    availableOptions
        .add(Availability(color: Color(0XFF0ACF83), label: "Available"));

    init();
    // TODO: implement initState
    super.initState();
  }

  init() async {
    _googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1 & destination=23.3, 23.5&travelmode=driving&dir_action=navigate';

    markerPosition = LatLng(
      56.1304,
      106.3468,
    ); //LatLng(company.locationLat, company.locationLong);
    this.initialCameraPosition = CameraPosition(
      target: markerPosition,
      zoom: 10,
      tilt: 59.440717697143555,
    );

    setState(() {});
  }

  final picker = ImagePicker();
  _imgFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null)
        _image = File(pickedFile.path);
      else
        print('No Image Selected');
    });
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null)
        _image = File(pickedFile.path);
      else
        print('No Image Selected');
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Form(
          key: _formKey,
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

              buttonsArea(),

              form(),

              publishButton(),
            ],
          ),
        ),
      ),
    );
  }

  googleMap() {
    return Stack(
      children: [
        Container(
          // height: 500.h,
          // width: 1.sw,
          height: 155.h,
          width: 350.w,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController ctrlr) {
              controller.complete(ctrlr);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
          ),
        ),
        Align(
          child: IconButton(
              onPressed: () {
                _goToCurrentPosition();
              },
              icon: Icon(Icons.gps_fixed)),
        )
      ],
    );
  }

  Future<void> _goToCurrentPosition() async {
    await _locationService.getCurrentLocation();
    var lat = _locationService.currentLocation!.latitude;
    var long = _locationService.currentLocation!.longitude;
    _kLocation = CameraPosition(
        bearing: 192.8334901395799,
        target:
            LatLng(lat, long), //LatLng(37.43296265331129, -122.08832357078792),
        // tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    final GoogleMapController cntrlr = await controller.future;
    cntrlr.animateCamera(CameraUpdate.newCameraPosition(_kLocation));
    setState(() {});
  }

  addMarker(lat, long) {
    int i = 0;
    i = i + 1;
    markers.add(Marker(
      markerId: MarkerId("$lat _ $long $i"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(lat, long),
    ));
  }

  form() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 0, top: 32),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 46.h,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            child: TextFormField(
              textAlign: TextAlign.center,
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Invalid field";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                serviceToBeAdded.title = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "TITLE OF SERVICE",
                  contentPadding: EdgeInsets.only(bottom: 4.h),
                  hintStyle: headingTextStyle.copyWith(
                    fontSize: 13,
                    fontFamily: robottoFontTextStyle,
                  )),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            alignment: Alignment.center,
            height: 132.h,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            child: TextFormField(
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Invalid field";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                serviceToBeAdded.description = value;
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "SERVICE DESCRIPTION",
                  contentPadding: EdgeInsets.only(bottom: 4.h),
                  hintStyle: headingTextStyle.copyWith(
                    fontSize: 13,
                    fontFamily: robottoFontTextStyle,
                  )),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            alignment: Alignment.center,
            height: 46.h,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            child: TextFormField(
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Invalid field";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                serviceToBeAdded.price = value;
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "PRICE",
                  contentPadding: EdgeInsets.only(bottom: 4.h),
                  hintStyle: headingTextStyle.copyWith(
                    fontSize: 13,
                    fontFamily: robottoFontTextStyle,
                  )),
            ),
          ),
          SizedBox(height: 20.h),
          // ImageContainer(
          //   assets: "$assets/map.png",
          //   height: 155.h,
          //   width: 1.sw,
          // ),
          googleMap(),
          SizedBox(height: 20.h),
          Container(
            alignment: Alignment.center,
            height: 46.h,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            child: TextFormField(
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Invalid field";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                serviceToBeAdded.category = value;
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "CATEGORY",
                  contentPadding: EdgeInsets.only(bottom: 4.h),
                  hintStyle: headingTextStyle.copyWith(
                    fontSize: 13,
                    fontFamily: robottoFontTextStyle,
                  )),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            alignment: Alignment.center,
            height: 46.h,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            child: TextFormField(
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Invalid field";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                serviceToBeAdded.websiteLink = value;
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "WEBSITE LINK",
                  contentPadding: EdgeInsets.only(bottom: 4.h),
                  hintStyle: headingTextStyle.copyWith(
                    fontSize: 13,
                    fontFamily: robottoFontTextStyle,
                  )),
            ),
          ),
          SizedBox(height: 40.h),
          GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: _image != null
                ? Image.file(
                    _image!,
                    height: 112.h,
                    width: 1.sw,
                    fit: BoxFit.cover,
                  )
                : ImageContainer(
                    assets: "$assets/upload01.png",
                    height: 112.h,
                    width: 1.sw,
                  ),
          ),
          SizedBox(
            height: 22.h,
          ),
          Row(
            children: [
              Text(
                "Add Service Availability".toUpperCase(),
                style: headingTextStyle.copyWith(
                  fontSize: 13,
                  fontFamily: robottoFontTextStyle,
                ),
              ),
              SizedBox(width: 12.w),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // " green : meaning avalaible product- yellow : available soon and red : Not avaialble"

              children: List.generate(
                availableOptions.length,
                (index) => GestureDetector(
                  onTap: () {
                    print("tapped===>");
                    for (int i = 0; i < availableOptions.length; i++) {
                      if (i == index) {
                        availableOptions[i].isSelected = true;
                        serviceToBeAdded.availability =
                            availableOptions[i].label;
                        print(availableOptions[i].isSelected);
                      } else {
                        availableOptions[i].isSelected = false;
                      }

                      print(availableOptions[i].isSelected);
                    }
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 26.h,
                        width: 26.w,
                        padding: availableOptions[index].isSelected!
                            ? EdgeInsets.all(4.0)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: availableOptions[index].isSelected!
                                    ? Colors.black
                                    : Colors.transparent)),
                        child: Container(
                            height: 23.h,
                            width: 23.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: availableOptions[index].color)),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text("${availableOptions[index].label}",
                          style: bodyTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontFamily: robottoFontTextStyle))
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 25.h,
          ),
        ],
      ),
    );
  }

  publishButton() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 50.h, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 26.h,
            width: 172.w,
            child: RoundedRaisedButton(
              buttonText: "PUBLISH",
              color: Colors.white,
              textColor: primaryColor,
              onPressed: () {
                print(":");
                // Get.offAll(() => RootProviderScreen(
                //   index: 4,
                // ));
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (_image != null) {
                    final providerName =
                        "${locator<AuthService>().providerProfile!.businessName}";
                    serviceToBeAdded.providerName = providerName;
                    serviceToBeAdded.imgFile = _image;
                    serviceToBeAdded.isBooked = 'No';
                    serviceToBeAdded.serviceBookingDate = Timestamp.now();
                    serviceToBeAdded.isConfirmed = 'No';
                    print(serviceToBeAdded.serviceBookingDate);
                    serviceToBeAdded.providerId =
                        locator<LocalStorageService>().accessTokenProvider;
                    serviceToBeAdded.location = Locationn(
                      lat:
                          _locationService.currentLocation!.latitude.toString(),
                      long: _locationService.currentLocation!.longitude
                          .toString(),
                    );
                    Get.back(result: serviceToBeAdded);
                  } else {
                    Get.dialog(
                      RequestFailedDialog(
                        errorMessage: "add image before moving ahead",
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
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
        ),
      ],
    );
  }

  buttonsArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "ADD NEW SERVICE LIST",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");
                  }),
            ),
          ],
        )
      ],
    );
  }
}
