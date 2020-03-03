import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multacc/common/constants.dart';

class ContactShortcut extends StatelessWidget {
  final IconData icon;

  ContactShortcut({@required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(40, 40),
      child: ClipOval(
        child: Material(
          color: kBackgroundColorLight,
          child: InkWell(
            onTap: () {},
            child: Icon(icon, size: 25),
            ),
          ),
        ),
    );
  }
}