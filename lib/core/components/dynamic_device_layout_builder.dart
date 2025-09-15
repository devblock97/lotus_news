import 'package:flutter/material.dart';

class DynamicDeviceLayoutBuilder extends StatelessWidget {
  const DynamicDeviceLayoutBuilder({
    super.key,
    required this.mobileView,
    required this.tabletView
  });

  final Widget Function(BuildContext context) mobileView;
  final Widget Function(BuildContext context) tabletView;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return tabletView(context);
        } else {
          return mobileView(context);
        }
      },
    );
  }
}
