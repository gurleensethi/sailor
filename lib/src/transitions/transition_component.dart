import 'package:flutter/cupertino.dart';

abstract class TransitionComponent {
  Widget buildChildWithTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}
