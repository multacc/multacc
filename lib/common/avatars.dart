import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:multacc/common/theme.dart';

/// Contains static methods that return proper CircleAvatar widgets
class Avatars {
  static Widget buildContactAvatar({@required Uint8List memoryImage, IconData defaultIcon = Icons.person, double radius = 20.0}) {
    return memoryImage != null && memoryImage.length > 0
        ? CircleAvatar(backgroundImage: MemoryImage(memoryImage), radius: radius, backgroundColor: Colors.transparent)
<<<<<<< HEAD
        : CircleAvatar(child: Icon(defaultIcon, size: radius), backgroundColor: kBackgroundColorLight, radius: radius);
=======
        : CircleAvatar(child: Icon(Icons.person, size: radius), backgroundColor: kBackgroundColorLight, radius: radius);
>>>>>>> 1937f90e6b5187690050e5dc45b7f3f9d74acfa4
  }
}
