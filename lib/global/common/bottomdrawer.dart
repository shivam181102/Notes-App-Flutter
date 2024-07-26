import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';

class Bottomdrawer extends StatelessWidget {
  double height;

  Widget child;
  Bottomdrawer({super.key, required this.height, required this.child});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        height: height,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: dark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: child);
  }
}
