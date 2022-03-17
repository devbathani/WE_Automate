import 'dart:developer';

import 'package:flutter/material.dart';


  Widget chip({required String text, void Function()? onPressed, required Color color}) {
    return ActionChip(
      label: Text(text),
      backgroundColor: color,
      onPressed: onPressed ??
          () {
            log("not implemented");
          },
    );
  }

  