import 'package:flutter/widgets.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getPadding(BuildContext context) {
    if (isDesktop(context)) return 48.0;
    if (isTablet(context)) return 32.0;
    return 16.0;
  }

  static double getCardHeight(BuildContext context) {
    if (isDesktop(context)) return 180.0;
    if (isTablet(context)) return 160.0;
    return 140.0;
  }

  static double getImageHeight(BuildContext context) {
    if (isDesktop(context)) return 250.0;
    if (isTablet(context)) return 200.0;
    return 150.0;
  }
}
