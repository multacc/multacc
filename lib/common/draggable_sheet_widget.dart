import 'package:flutter/material.dart';

/// Reusable bottom sheet that takes up 70% of the screen and can be dragged to fill screen
showDraggableSheet(BuildContext context, Widget child) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => _showDraggableScrollableSheet(child),
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}

Widget _showDraggableScrollableSheet(Widget child) {
  return DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.7,
    // maxChildSize: 0.99,
    builder: (context, scrollController) => SingleChildScrollView(
      controller: scrollController,
      child: child,
    ),
  );
}
