import 'package:flutter/material.dart';

/// Extend this class to provide Sailor with a custom transtion.
abstract class CustomSailorTransition {
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}
