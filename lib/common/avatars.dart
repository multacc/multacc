import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:multacc/common/theme.dart';

/// Contains static methods that return proper CircleAvatar widgets
class Avatars {
  static Widget buildContactAvatar({@required Uint8List memoryImage, double radius = 20.0}) {
    return memoryImage != null && memoryImage.length > 0
        ? CircleAvatar(backgroundImage: MemoryImage(memoryImage), radius: radius, backgroundColor: Colors.transparent)
        : CircleAvatar(child: Icon(Icons.person, size: radius), backgroundColor: kBackgroundColorLight, radius: radius);
  }
}
