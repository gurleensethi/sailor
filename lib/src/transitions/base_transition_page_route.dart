import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class BaseTransitionPageRoute extends PageRouteBuilder {
  final TransitionComponent transitionComponent;
  final Duration duration;
  final Curve curve;

  BaseTransitionPageRoute({
    this.transitionComponent,
    @required WidgetBuilder builder,
    @required RouteSettings settings,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  })  : assert(transitionComponent != null),
        assert(curve != null),
        assert(duration != null),
        super(pageBuilder: (context, anim1, anim2) => builder(context));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: this.curve,
    );

    return transitionComponent.buildChildWithTransition(
        context, curvedAnimation, secondaryAnimation, child);
  }

  @override
  Duration get transitionDuration => this.duration;
}
