import 'package:flutter/material.dart';
import 'package:chatapp/utils/dimensions.dart';

class ResponsiveLayoutScreen extends StatelessWidget {
  final Widget webscreenlayout;
  final Widget mobilescreenlayout;
  const ResponsiveLayoutScreen(
      {super.key,
      required this.mobilescreenlayout,
      required this.webscreenlayout});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      if (constraints.maxWidth > webScreen) {
        //web screen layout
        return webscreenlayout;
      } else {
        //mobile screen
        return mobilescreenlayout;
      }
    });
  }
}
