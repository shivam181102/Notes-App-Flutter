import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';

void showBottomDrawer(BuildContext context, double height, Widget child) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
          height: height,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: dark(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: child);
    },
  );
}
