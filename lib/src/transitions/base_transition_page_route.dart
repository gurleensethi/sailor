import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class BaseTransitionPageRoute extends PageRouteBuilder {
  final TransitionComponent transitionComponent;

  BaseTransitionPageRoute({
    this.transitionComponent,
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(pageBuilder: (context, anim1, anim2) => builder(context));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return transitionComponent.buildChildWithTransition(
        context, animation, secondaryAnimation, child);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
