import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? hintText;
  final bool? obscureText;
  TextEditingController? controller;

  CustomTextField({
    this.hintText,
    this.onSaved,
    this.validator,
    this.obscureText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      maxLines: 1,
      keyboardType: TextInputType.name,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      obscureText: obscureText!,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 10.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0XFF1b77f2),
            width: 7,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0XFF1b77f2),
            width: 7,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Colors.grey,
            fontSize: 25.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
