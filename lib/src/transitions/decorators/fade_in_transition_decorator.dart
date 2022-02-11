import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';
import 'package:sailor/src/transitions/transiton_decorator.dart';

class FadeInTransitionDecorator extends TransitionDecorator {
  FadeInTransitionDecorator({
    TransitionComponent? transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: animation,
      child: transitionComponent!.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}
