import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class BaseTransitionPageRoute extends PageRouteBuilder {
  final TransitionComponent transitionComponent;

  // TODO(gurleensethi): Add params for Duration and animation curves.

  BaseTransitionPageRoute({
    this.transitionComponent,
    @required WidgetBuilder builder,
    @required RouteSettings settings,
  })  : assert(transitionComponent != null),
        super(pageBuilder: (context, anim1, anim2) => builder(context));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return transitionComponent.buildChildWithTransition(
        context, animation, secondaryAnimation, child);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
