import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class ConcreteTransitionComponent implements TransitionComponent {
  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}
