import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';

/// Concrete implementation of [TransitionComponent].
/// It returns the [child] as it is, without applying any
/// sort of transitions.
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
