

import 'package:flutter/material.dart';

mixin MixinComponent {


  Widget bgContainer({required Widget child, double radius = 12, double marginH = 0, double marginV = 0, double paddingH = 0, double paddingV = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 0.5),
      ),
      child: child,
    );
  }

}