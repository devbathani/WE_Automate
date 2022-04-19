import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:antonx_flutter_template/core/constants/colors.dart';

class RoundedRaisedButton extends StatelessWidget {
  final buttonText;
  final onPressed;
  final color;
  final textColor;
  final fontWeight;
  final freeTrialColor;
  RoundedRaisedButton(
      {this.buttonText,
      this.freeTrialColor,
      this.fontWeight = FontWeight.bold,
      this.onPressed,
      this.color = primaryColor,
      this.textColor = Colors.white,
      });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: RaisedButton(
        onPressed: this.onPressed,
        color: this.color,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 2.w, color: this.freeTrialColor ?? primaryColor),
            // this.color == primaryColor ? Colors.white : Colors.black),
            borderRadius: BorderRadius.circular(6.0)),
        padding: const EdgeInsets.only(),
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 88.0,
              minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            '$buttonText',
            style: bodyTextStyle.copyWith(
                fontFamily: robottoFontTextStyle,
                fontSize: 13.sp,
                color: this.textColor,
                letterSpacing: 0.4,
                fontWeight: this.fontWeight ?? FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
