import 'package:flutter/material.dart';

/// Component interace for decorator pattern used in building
/// nested page transitions.
abstract class TransitionComponent {
  Widget buildChildWithTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}
