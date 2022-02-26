import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kHead1 = TextStyle(
  fontFamily: 'sfsafsd',
  fontSize: 20,
  color: Colors.black,
);
var comforteeFontStyle = GoogleFonts.comfortaa().fontFamily;
var robottoFontTextStyle = GoogleFonts.roboto().fontFamily;
// var sfProText = GoogleFonts..fontFamily;

var headingTextStyle = TextStyle(
  fontFamily: comforteeFontStyle,
  fontSize: 36.sp,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
var subHeadingTextstyle = TextStyle(
  fontFamily: comforteeFontStyle,
  fontWeight: FontWeight.w600,
  fontSize: 24,
  color: Colors.black,
);
var bodyTextStyle = TextStyle(
  fontFamily: comforteeFontStyle,
  fontSize: 14,
  color: Colors.black,
);
var subBodyTextStyle = TextStyle(
  fontFamily: comforteeFontStyle,
  fontSize: 12,
  color: Colors.black,
);

///Chat textStyles
final chatTextStyleLeft = TextStyle(
    color: Colors.grey, fontSize: 13.sp, fontFamily: robottoFontTextStyle);

final chatTextStyleRight = TextStyle(
  color: Colors.black,
  fontSize: 13.sp,
  fontFamily: robottoFontTextStyle,
);

final chatTimeTS = TextStyle(
    fontSize: 12,
    color: Color(0xFFB2BEC3),
    fontWeight: FontWeight.w600,
    fontFamily: robottoFontTextStyle);

///
const BorderRadius chatBorderRadiusRight = BorderRadius.only(
  topLeft: Radius.circular(6.0),
  topRight: Radius.circular(6.0),
  bottomLeft: Radius.circular(6.0),
);

///
/// All corners rounded except bottom left
///
const BorderRadius chatBorderRadiusLeft = BorderRadius.only(
  topLeft: Radius.circular(6.0),
  bottomRight: Radius.circular(6.0),
  topRight: Radius.circular(6.0),
);
