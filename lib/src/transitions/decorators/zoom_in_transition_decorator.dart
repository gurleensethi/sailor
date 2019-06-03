import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';
import 'package:sailor/src/transitions/transiton_decorator.dart';

class ZoomInTransitionDecorator extends TransitionDecorator {
  ZoomInTransitionDecorator({TransitionComponent transitionComponent})
      : assert(transitionComponent != null),
        super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: animation,
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}
