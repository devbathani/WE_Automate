import 'package:flutter/material.dart';


Column durationGap(int selected, String text, {void Function(int?)? onChanged}) {
    return Column(
      children: [
        Text(text),
        DropdownButton<int>(
            value: selected,
            items: [
              const DropdownMenuItem(
                child: Text('0 min'),
                value: 0,
              ),
              const DropdownMenuItem(
                child: Text('10 min'),
                value: 10,
              ),
              const DropdownMenuItem(
                child: Text('20 min'),
                value: 20,
              ),
              const DropdownMenuItem(
                child: Text('30 min'),
                value: 30,
              ),
              const DropdownMenuItem(
                child: Text('40 min'),
                value: 40,
              ),
              const DropdownMenuItem(
                child: Text('50 min'),
                value: 50,
              ),
              const DropdownMenuItem(
                child: Text('60 min'),
                value: 60,
              ),
            ],
            onChanged: onChanged ?? (val) {}),
      ],
    );
  }
