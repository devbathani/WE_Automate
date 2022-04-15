import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? hintText;
  final bool? obscureText;

  CustomTextField({
    this.hintText,
    this.onSaved,
    this.validator,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      maxLines: 1,
      keyboardType: TextInputType.name,
      style: GoogleFonts.poppins(
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
        hintText: hintText,
        hintStyle: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Colors.grey,
            fontSize: 25.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
