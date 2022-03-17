import 'package:flutter/material.dart';


Column staticCard(String title, String text) {
    return Column(
      children: [
        Text(title),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          ),
          borderOnForeground: true,
          elevation: 2,
        ),
      ],
    );
  }