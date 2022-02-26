import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSingleRadioButton extends StatelessWidget {
  final bool isSelected;
  final onPressed;
  CustomSingleRadioButton({this.isSelected = false, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 14,
          width: 14,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isSelected ? primaryColor : Colors.transparent),
          ),
        ),
      ),
    );
  }
}
