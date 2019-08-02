import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/transition_component.dart';

class BaseTransitionPageRoute extends PageRouteBuilder {
  final TransitionComponent transitionComponent;
  final Duration duration;
  final Curve curve;
  final bool useDefaultPageTransition;

  BaseTransitionPageRoute({
    this.transitionComponent,
    @required WidgetBuilder builder,
    @required RouteSettings settings,
    this.duration,
    this.curve,
    this.useDefaultPageTransition = false,
  })  : assert(transitionComponent != null),
        assert(useDefaultPageTransition != null),
        super(
            pageBuilder: (context, anim1, anim2) => builder(context),
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (this.useDefaultPageTransition) {
      return Theme.of(context).pageTransitionsTheme.buildTransitions(
          this, context, animation, secondaryAnimation, child);
    }

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: this.curve ?? Curves.linear,
    );

    return transitionComponent.buildChildWithTransition(
        context, curvedAnimation, secondaryAnimation, child);
  }

  @override
  Duration get transitionDuration =>
      this.duration ?? Duration(milliseconds: 300);
}
