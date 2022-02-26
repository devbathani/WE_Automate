import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final bool? obscure;
  final String? errorText;
  final String? hintText;
  final bool? enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final validator;
  final double? fontSize;
  final String? label;
  final onSaved;
  final maxline;
  final onTap;
  final bool disableBorder;
  final onChanged;
  final inputType;
  CustomTextField(
      {this.controller,
      this.onTap,
      this.inputType = TextInputType.text,
      this.disableBorder = false,
      this.label,
      this.maxline = 1,
      this.obscure = false,
      this.enabled = true,
      this.validator,
      this.errorText,
      this.fontSize = 13.0,
      this.hintText,
      this.onSaved,
      this.suffixIcon,
      this.prefixIcon,
      this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: this.inputType,
      maxLines: this.maxline,
      onSaved: onSaved,
      enabled: enabled,
      style: bodyTextStyle.copyWith(
//              color: Color(0XFF686868),
          fontFamily: robottoFontTextStyle,
          color: Colors.black,
          fontSize: fontSize),
      // ),
      cursorColor: primaryColor,
      controller: this.controller,
      obscureText: this.obscure!,
      validator: validator ??
          (value) {
            if (value != null) {
              return this.errorText;
            } else {
              return null;
            }
          },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        // alignLabelWithHint: true,
        // prefixIconConstraints: BoxConstraints(
//            maxHeight: 25.h,
//            maxWidth: 25.w,
        // ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        //   child: prefixIcon ?? Container(),
        // ),
        suffixIcon: Padding(
            padding: const EdgeInsets.only(),
            child: suffixIcon != null ? suffixIcon : Container()),
        suffixIconConstraints: BoxConstraints(maxHeight: 40, maxWidth: 50),
        focusedBorder: OutlineInputBorder(
          // borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide(color: Colors.black, width: 1.4.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.4.w),
          // borderRadius: BorderRadius.circular(14.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.4.w),
          // borderRadius: BorderRadius.circular(14.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.4.w),
          // borderRadius: BorderRadius.circular(14.0),
        ),
        contentPadding: EdgeInsets.only(
            left: 21.0, top: double.parse(maxline.toString()) > 1 ? 120 : 0),
        hintText: this.hintText,
        hintStyle: bodyTextStyle.copyWith(
//              color: Color(0XFF686868),
            fontFamily: robottoFontTextStyle,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: fontSize),
        // ),
      ),
    );
  }
}
