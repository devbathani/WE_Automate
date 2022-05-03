import 'dart:async';
import 'dart:io';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/models/availability.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/locator.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/services-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/view_state.dart';
import '../../../../custom_widgets/custom_text_field.dart';
import '../services-view-model.dart';

class EditServiceScreen extends StatefulWidget {
  final SErvice? service;
  const EditServiceScreen({@required this.service});

  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final Completer<GoogleMapController> controller = Completer();
  late CameraPosition initialCameraPosition;
  final _locationService = locator<LocationService>();
  Set<Marker> markers = Set<Marker>();
  final _dbService = locator<DatabaseService>();
  // var serviceToBeAdded = SErvice();

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

    for (int i = 0; i < availableOptions.length; i++) {
      if (availableOptions[i].label == widget.service!.availability) {
        availableOptions[i].isSelected = true;
      }
    }
    init();
    super.initState();
  }

  init() async {
    _googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1 & destination=23.3, 23.5&travelmode=driving&dir_action=navigate';

    markerPosition = LatLng(34.015137,
        71.524918); //LatLng(company.locationLat, company.locationLong);
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
    return ChangeNotifierProvider(
      create: (context) => ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.loading,
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      ),
                      avatarArea(),
                      form(),
                      publishButton(model),
                    ],
                  ),
                ),
              ),
            ),
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
          width: 1.sw,
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
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        children: [
          CustomTextField(
            controller: TextEditingController(text: widget.service!.title),
            hintText: "Title of Service",
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Invalid field";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              widget.service!.title = value;
            },
            obscureText: false,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            controller:
                TextEditingController(text: widget.service!.description),
            hintText: "Service Description",
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Invalid field";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              widget.service!.description = value;
            },
            obscureText: false,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            controller: TextEditingController(text: widget.service!.price),
            hintText: "Price",
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Invalid field";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              widget.service!.price = value;
            },
            obscureText: false,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            controller: TextEditingController(text: widget.service!.category),
            hintText: "Category",
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Invalid field";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              widget.service!.category = value;
            },
            obscureText: false,
          ),
          SizedBox(height: 20.h),
          googleMap(),
          SizedBox(height: 20.h),
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
                : FadeInImage.assetNetwork(
                    placeholder: "$assets/placeholder.jpeg",
                    image: widget.service!.imgUrl!,
                    height: 112.h,
                    fit: BoxFit.cover,
                    width: 1.sw,
                  ),
          ),
        ],
      ),
    );
  }

  publishButton(ServicesViewModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              print(":");

              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final providerName =
                    "${locator<AuthService>().providerProfile!.businessName}";
                widget.service!.providerName = providerName;
                widget.service!.imgFile = _image;
                widget.service!.providerId =
                    locator<LocalStorageService>().accessTokenProvider;
                widget.service!.location = Locationn(
                  lat: _locationService.currentLocation!.latitude.toString(),
                  long: _locationService.currentLocation!.longitude.toString(),
                );
                await model.updateService(widget.service!);
                Get.to(() => ServicesScreen());
              }
            },
            child: Container(
              height: 70.h,
              width: 330.w,
              decoration: BoxDecoration(
                color: Color(0xff8B53FF),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60.w,
                    ),
                    Image.asset(
                      "$assets/female.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      "Publish",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w800,
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

  avatarArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          "Edit Service Details",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
